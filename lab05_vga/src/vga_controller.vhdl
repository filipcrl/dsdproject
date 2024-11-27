--=============================================================================
-- @file vga_controller.vhdl
--=============================================================================
-- Standard library
library ieee;
-- Standard packages
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Packages
library work;
use work.dsd_prj_pkg.all;

--=============================================================================
--
-- vga_controller
--
-- @brief This file specifies a VGA controller circuit
--
--=============================================================================

--=============================================================================
-- ENTITY DECLARATION FOR VGA_CONTROLLER
--=============================================================================
entity vga_controller is
  port (
    CLKxCI : in std_logic;
    RSTxRI : in std_logic;

    -- Data/color input
    RedxSI   : in std_logic_vector(COLOR_BW - 1 downto 0);
    GreenxSI : in std_logic_vector(COLOR_BW - 1 downto 0);
    BluexSI  : in std_logic_vector(COLOR_BW - 1 downto 0);

    -- Coordinate output
    XCoordxDO : out unsigned(COORD_BW - 1 downto 0);
    YCoordxDO : out unsigned(COORD_BW - 1 downto 0);

    -- Timing output
    HSxSO : out std_logic;
    VSxSO : out std_logic;

    -- Data/color output
    RedxSO   : out std_logic_vector(COLOR_BW - 1 downto 0);
    GreenxSO : out std_logic_vector(COLOR_BW - 1 downto 0);
    BluexSO  : out std_logic_vector(COLOR_BW - 1 downto 0)
  );
end vga_controller;

--=============================================================================
-- ARCHITECTURE DECLARATION
--=============================================================================
architecture rtl of vga_controller is

  type VgaHorizontalFSM_Type is (
    BackPorch, Display, FrontPorch, Pulse
  );

  type VgaVerticalFSM_Type is (
    BackPorch, Display, FrontPorch, Pulse
  );

  signal HStatexDN, HStatexDP : VgaHorizontalFSM_Type;
  signal VStatexDN, VStatexDP : VgaVerticalFSM_Type;

  signal HCntxDN, HCntxDP   : unsigned(COORD_BW - 1 downto 0);
  signal VCntxDN, VCntxDP   : unsigned(COORD_BW - 1 downto 0);
  signal Tst : unsigned(COORD_BW - 1 downto 0);
  signal HPulseTransitionxS : std_logic;

--=============================================================================
-- ARCHITECTURE BEGIN
--=============================================================================
begin

  process (all)
  begin
    HPulseTransitionxS <= '0';
    HStatexDN <= HStatexDP;
    HCntxDN <= HCntxDP + 1;

    case HStatexDP is
      when Pulse =>
        if (HCntxDP = HS_PULSE - 1) then
          HStatexDN <= BackPorch;
          HCntxDN <= (others => '0');
          HPulseTransitionxS <= '1';
        end if;
      when BackPorch =>
        if (HCntxDP = HS_BACK_PORCH - 1) then
          HStatexDN <= Display;
          HCntxDN <= (others => '0');
        end if;
      when Display =>
        if (HCntxDP = HS_DISPLAY - 1) then
          HStatexDN <= FrontPorch;
          HCntxDN <= (others => '0');
        end if;
      when FrontPorch =>
        if (HCntxDP = HS_FRONT_PORCH - 1) then
          HStatexDN <= Pulse;
          HCntxDN <= (others => '0');
        end if;
    end case;
  end process;

  process (all)
  begin
    VStatexDN <= VStatexDP;
    VCntxDN <= VCntxDP + 1 when HPulseTransitionxS = '1' else VCntxDP;
    Tst <= VCntxDP + 1 when HPulseTransitionxS = '1' else VCntxDP;

    case VStatexDP is
      when Pulse =>
        if (Tst = VS_PULSE) then
          VStatexDN <= BackPorch;
          VCntxDN <= (others => '0');
        end if;
      when BackPorch =>
        if (Tst = VS_BACK_PORCH) then
          VStatexDN <= Display;
          VCntxDN <= (others => '0');
        end if;
      when Display =>
        if (Tst = VS_DISPLAY) then
          VStatexDN <= FrontPorch;
          VCntxDN <= (others => '0');
        end if;
      when FrontPorch =>
        if (Tst = VS_FRONT_PORCH) then
          VStatexDN <= Pulse;
          VCntxDN <= (others => '0');
        end if;
    end case;
  end process;

  process (CLKxCI, RSTxRI)
  begin
    if (RSTxRI = '1') then
      HCntxDP <= (others => '0');
      VCntxDP <= (others => '0');

      HStatexDP <= Pulse;
      VStatexDP <= Pulse;
    elsif (CLKxCI'event and CLKxCI = '1') then
      HCntxDP <= HCntxDN;
      VCntxDP <= VCntxDN;

      HStatexDP <= HStatexDN;
      VStatexDP <= VStatexDN;
    end if;
  end process;

  HSxSO <= HS_POLARITY when HStatexDP = Pulse else not(HS_POLARITY);
  VSxSO <= VS_POLARITY when VStatexDP = Pulse else not(VS_POLARITY);

  XCoordxDO <= HCntxDP when HStatexDP = Display else (others => '0');
  YCoordxDO <= VCntxDP when VStatexDP = Display else (others => '0');

  RedxSO   <= RedxSI;
  GreenxSO <= GreenxSI;
  BluexSO  <= BluexSI; 

end rtl;
--=============================================================================
-- ARCHITECTURE END
--=============================================================================
