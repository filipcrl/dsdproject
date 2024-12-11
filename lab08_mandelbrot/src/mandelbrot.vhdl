--=============================================================================
-- @file mandelbrot.vhdl
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
-- mandelbrot
--
-- @brief This file specifies a basic circuit for mandelbrot
--
--=============================================================================

--=============================================================================
-- ENTITY DECLARATION FOR MANDELBROT
--=============================================================================
entity mandelbrot is
  port (
    CLKxCI : in std_logic;
    RSTxRI : in std_logic;

    WExSO   : out std_logic;
    XxDO    : out unsigned(COORD_BW - 1 downto 0);
    YxDO    : out unsigned(COORD_BW - 1 downto 0);
    ITERxDO   : out unsigned(MEM_DATA_BW-1 downto 0)
  );
end entity mandelbrot;

--=============================================================================
-- ARCHITECTURE DECLARATION
--=============================================================================
architecture rtl of mandelbrot is
  -- Format -- 
  constant N_BITS_SHORT : natural := N_BITS + 1;
  constant N_BITS_LONG : natural := N_BITS + 5;

  -- Memory size --
  constant HS_MANDELBROT     : natural   := HS_DISPLAY/4;
  constant VS_MANDELBROT     : natural   := VS_DISPLAY/4;

  -- 256x256 Increment Low res --
  constant C_RE_INC_LR : signed(N_BITS - 1 downto 0) := to_signed(3 * 2**(-8 + N_FRAC), N_BITS); -- Q3.15
  constant C_IM_INC_LR : signed(N_BITS - 1 downto 0) := to_signed(5 * 2**(-9 + N_FRAC), N_BITS); -- Q3.15
  
  -- Reshape signed types -- 
  function reshape(
      SIGNED_IN : signed;
      N_FRAC_CUT  : integer;
      N_BITS_OUT : integer
  ) return signed is
  begin
      return resize(shift_right(SIGNED_IN, N_FRAC_CUT), N_BITS_OUT);
  end function reshape;

  -- X --
  signal XxDPrv, XxDP, XxDN : unsigned(COORD_BW-1 downto 0);

  -- Y --
  signal YxDPrv, YxDP, YxDN : unsigned(COORD_BW-1 downto 0);
 
  -- Re(C) --
  signal CRExDPrev, CRExDP, CRExDN : signed(N_BITS_SHORT-1 downto 0);

  -- Im(C) --
  signal CIMxDPrev, CIMxDP, CIMxDN : signed(N_BITS_SHORT-1 downto 0);

  -- Re(Z) --
  signal ZRExDPrev, ZRExDP, ZRExDN : signed(N_BITS_SHORT-1 downto 0);

  -- Im(Z) --
  signal ZIMxDPrev, ZIMxDP, ZIMxDN : signed(N_BITS_SHORT-1 downto 0);

  -- Norm(Z) --
  signal ZNORMxDP, ZNORMxDN : signed(N_BITS_LONG-1 downto 0);

  -- Default norm --
  constant Z_NORM_0 : signed(N_BITS_LONG-1 downto 0) :=
    reshape(C_RE_0 * C_RE_0 + C_IM_0 * C_IM_0, N_FRAC, N_BITS_LONG);

  -- Iteration Number --
  signal ITERxDPrev, ITERxDP, ITERxDN : unsigned(MEM_DATA_BW-1 downto 0);

  -- Write enable signal --
  signal WExS : std_logic;
begin
  -- X/Y Loop --
  process (CLKxCI, RSTxRI)
  begin
    if (RSTxRI = '1') then
      XxDPrv <= (others => '0');
      XxDP <= (others => '0');

      YxDPrv <= (others => '0');
      YxDP <= (others => '0');

      CRExDPrev <= resize(C_RE_0, N_BITS_SHORT);
      CRExDP <= resize(C_RE_0, N_BITS_SHORT);

      CIMxDPrev <= resize(C_IM_0, N_BITS_SHORT);
      CIMxDP <= resize(C_IM_0, N_BITS_SHORT);
    elsif (CLKxCI'event and CLKxCI='1') then
      XxDPrv <= XxDP;
      XxDP <= XxDN;

      YxDPrv <= YxDP;
      YxDP <= YxDN;

      CRExDPrev <= CRExDP;
      CRExDP <= CRExDN;
      
      CIMxDPrev <= CIMxDP;
      CIMxDP <= CIMxDN;
    end if;
  end process;

  -- X/Y Computation --
  process (all)
  begin
  XxDN <= XxDP;
  if (WExS='1') then
    XxDN <= XxDP+1;
    if (XxDP=HS_MANDELBROT-1) then
      XxDN <= (others => '0');
    end if;
  end if;

  YxDN <= YxDP;
  if (WExS='1') then
    YxDN <= YxDP;
    if (YxDP=VS_DISPLAY-1) and (XxDP=HS_MANDELBROT-1) then
      YxDN <= (others => '0');
    elsif (XxDP=HS_MANDELBROT-1) then
      YxDN <= YxDP+1;
    end if;
  end if;
  end process;
  
  -- C Computation --
  process (all)
  begin
  CRExDN <= CRExDP;
  if (WExS='1') then
    CRExDN <= CRExDP + C_RE_INC_LR;
    if (XxDP=HS_MANDELBROT-1) then
      CRExDN <= resize(C_RE_0, N_BITS_SHORT);
    end if;
  end if;
  
  CIMxDN <= CIMxDP;
  if (WExS='1') then
    CIMxDN <= CIMxDP;
    if (YxDP=VS_DISPLAY-1) then
      CIMxDN <= resize(C_IM_0, N_BITS_SHORT);
    elsif (XxDP=HS_MANDELBROT-1) then
      CIMxDN <= CIMxDP + C_IM_INC_LR;
    end if;
  end if;
  end process;

  -- Iteration loop --
  process (CLKxCI, RSTxRI)
  begin
    if (RSTxRI = '1') then
      ZRExDPrev <= resize(C_RE_0, N_BITS_SHORT);
      ZRExDP <= resize(C_RE_0, N_BITS_SHORT);

      ZIMxDPrev <= resize(C_IM_0, N_BITS_SHORT);
      ZIMxDP <= resize(C_IM_0, N_BITS_SHORT);

      ZNORMxDP <= Z_NORM_0;

      ITERxDPrev <= (others => '0');
      ITERxDP <= (others => '0');

      WExS <= '0';
    elsif (CLKxCI'event and CLKxCI='1') then
      ZRExDPrev <= ZRExDP;
      ZRExDP <= ZRExDN;

      ZIMxDPrev <= ZIMxDP;
      ZIMxDP <= ZIMxDN;

      ZNORMxDP <= ZNORMxDN;
      
      ITERxDPrev <= ITERxDP;
      ITERxDP <= ITERxDN;

      WExS <= '0' when (ZNORMxDP < ITER_LIM and ITERxDP < MAX_ITER) else
              '1';
    end if;
  end process;
  
  -- Re(z), Im(z) computation -- 
  process (all)
  begin
    ZRExDN <= CRExDN;
    ZIMxDN <= CIMxDN;
    ZNORMxDN <= reshape(CRExDN * CRExDN + CIMxDN * CIMxDN,
                        N_FRAC,
                        N_BITS_LONG);
    if (WExS = '0') then
      ZRExDN <= ZRExDP;
      ZIMxDN <= ZIMxDP;
      ZNORMxDN <= ZNORMxDP;
      if (ZNORMxDP < ITER_LIM and
          ITERxDP < MAX_ITER) then
        ZRExDN <= reshape(ZRExDP * ZRExDP - ZIMxDP * ZIMxDP + CRExDP*(2**N_FRAC),
                          N_FRAC,
                          N_BITS_SHORT);
        ZIMxDN <= reshape(2 * ZRExDP * ZIMxDP + CIMxDP*(2**N_FRAC),
                          N_FRAC,
                          N_BITS_SHORT);
        ZNORMxDN <=  reshape(ZRExDP * ZRExDP + ZIMxDP * ZIMxDP,
                             N_FRAC, 
                             N_BITS_LONG);
      end if;
    end if;
  end process;

  -- Next iteration computation -- 
  process (all)
  begin
    ITERxDN <= (others => '0');
    if (WExS = '0') then
      ITERxDN <= ITERxDP;
      if (ZNORMxDP < ITER_LIM and
          ITERxDP < MAX_ITER) then
        ITERxDN <= ITERxDP + 1;
      end if;
    end if;
  end process;

  -- Outputs --
  XxDO <= XxDP;
  YxDO <= YxDP;
  WExSO <= WExS;
  ITERxDO <= ITERxDPrev;
end architecture rtl;
--=============================================================================
-- ARCHITECTURE END
--=============================================================================
