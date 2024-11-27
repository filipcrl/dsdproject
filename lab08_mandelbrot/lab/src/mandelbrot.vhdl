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
    --DEBUG_CRxDO    : out signed(N_BITS - 1 downto 0);
    --DEBUG_CMxDO    : out signed(N_BITS - 1 downto 0);
    --DEBUG_ZRxDO    : out signed(N_BITS - 1 downto 0);
    --DEBUG_ZMxDO    : out signed(N_BITS - 1 downto 0);
    ITERxDO   : out unsigned(MEM_DATA_BW-1 downto 0)
    --DEBUG_OVERFLOW : out std_logic
  );
end entity mandelbrot;

--=============================================================================
-- ARCHITECTURE DECLARATION
--=============================================================================
architecture rtl of mandelbrot is
  signal X : unsigned(COORD_BW-1 downto 0);
  signal Y : unsigned(COORD_BW-1 downto 0);
  signal C_RE : signed(N_BITS-1 downto 0);
  signal C_IM : signed(N_BITS-1 downto 0);
  signal Z_RE : signed(N_BITS-1 downto 0);
  signal Z_IM : signed(N_BITS-1 downto 0);
  signal OVERFLOW : std_logic;
  signal ITERxD : unsigned(MEM_DATA_BW-1 downto 0);
  signal WExS : std_logic;
begin

  x_y_loop : process (CLKxCI, RSTxRI)
  begin
    if (RSTxRI = '1') then
      X <= (others => '0');
      Y <= (others => '0');
      C_RE <= C_RE_0;
      C_IM <= C_IM_0;
    elsif (CLKxCI'event and CLKxCI='1') then
      if (WExS='1') then
        X <= (others => '0') when (X=HS_DISPLAY-1) else 
          X+1;
        Y <= (others => '0') when (Y=VS_DISPLAY-1)  else 
          Y+1 when (X=HS_DISPLAY-1) else 
          Y;
        C_RE <= C_RE_0 when (X=HS_DISPLAY-1) else
          C_RE + C_RE_INC;
        C_IM <= C_IM_0 when (Y=VS_DISPLAY-1) else 
          C_IM + C_IM_INC when (X=HS_DISPLAY-1) else 
          C_IM;
      else
        X <= X;
        Y <= Y;
        C_RE <= C_RE;
        C_IM <= C_IM;
      end if;
    else
      X <= X;
      Y <= Y;
      C_RE <= C_RE;
      C_IM <= C_IM;
    end if;
  end process x_y_loop;

  conv_loop : process (CLKxCI, RSTxRI)
  begin
    if (RSTxRI = '1') then
      Z_RE <= C_RE_0;
      Z_IM <= C_IM_0;
      ITERxD <= (others => '0');
      WExS <= '0';
      XxDO <= (others => '0');
      YxDO <= (others => '0');
      OVERFLOW <= '0';
    elsif (CLKxCI'event and CLKxCI='1') then
      if (WExS='0') then
        if ((OVERFLOW='0') and 
            (shift_right(Z_RE * Z_RE + Z_IM * Z_IM, N_FRAC) < 4*(2**N_FRAC)) and
            ITERxD < MAX_ITER) then
          Z_RE <= resize(shift_right(Z_RE * Z_RE - Z_IM * Z_IM + C_RE*(2**N_FRAC), N_FRAC), N_BITS);
          Z_IM <= resize(shift_right(2 * Z_RE * Z_IM + C_IM*(2**N_FRAC), N_FRAC), N_BITS);
          if ((shift_right(Z_RE * Z_RE - Z_IM * Z_IM + C_RE*(2**N_FRAC), N_FRAC) > 4*(2**N_FRAC))
              or (shift_right(2 * Z_RE * Z_IM + C_IM*(2**N_FRAC), N_FRAC) > 4*(2**N_FRAC))) then
              OVERFLOW <= '1';
          else
              OVERFLOW <= '0';
          end if;
          ITERxD <= ITERxD + 1;
          WExS <= WExS;
          XxDO <= X;
          YxDO <= Y;
        else
          Z_RE <= Z_RE;
          Z_IM <= Z_IM;
          ITERxD <= ITERxD;
          WExS <= '1';
          XxDO <= X;
          YxDO <= Y;
          OVERFLOW <= OVERFLOW;
        end if;
      else
        Z_RE <= C_RE_0 when (X=HS_DISPLAY-1) else
          C_RE + C_RE_INC;
        Z_IM <= C_IM_0 when (Y=VS_DISPLAY-1) else 
          C_IM + C_IM_INC when (X=HS_DISPLAY-1) else 
          C_IM;
        ITERxD <= (others => '0');
        WExS <= '0';
        XxDO <= X;
        YxDO <= Y;
        OVERFLOW <= '0';
      end if;
    else
      Z_RE <= Z_RE;
      Z_IM <= Z_IM;
      ITERxD <= ITERxD;
      WExS <= WExS;
      XxDO <=  X;
      YxDO <= Y;
      OVERFLOW <= OVERFLOW;
    end if;
    --DEBUG_ZRxDO <= Z_RE;
    --DEBUG_ZMxDO <= Z_IM;
    ITERxDO <= ITERxD;
    WExSO <= WExS;
    --DEBUG_OVERFLOW <= OVERFLOW;
  end process conv_loop;

end architecture rtl;
--=============================================================================
-- ARCHITECTURE END
--=============================================================================
