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
  -- X --
  signal X_PREV : unsigned(COORD_BW-1 downto 0);
  signal X_CURR : unsigned(COORD_BW-1 downto 0);
  signal X_NEXT : unsigned(COORD_BW-1 downto 0);

  -- Y --
  signal Y_PREV : unsigned(COORD_BW-1 downto 0);
  signal Y_CURR : unsigned(COORD_BW-1 downto 0);
  signal Y_NEXT : unsigned(COORD_BW-1 downto 0);
 
  -- Re(C) --
  signal C_RE_PREV : signed(N_BITS+1-1 downto 0);
  signal C_RE_CURR : signed(N_BITS+1-1 downto 0);
  signal C_RE_NEXT : signed(N_BITS+1-1 downto 0);

  -- Im(C) --
  signal C_IM_PREV : signed(N_BITS+1-1 downto 0);
  signal C_IM_CURR : signed(N_BITS+1-1 downto 0);
  signal C_IM_NEXT : signed(N_BITS+1-1 downto 0);

  -- Re(Z) --
  signal Z_RE_PREV : signed(N_BITS+1-1 downto 0);
  signal Z_RE_CURR : signed(N_BITS+1-1 downto 0);
  signal Z_RE_NEXT : signed(N_BITS+1-1 downto 0);

  -- Im(Z) --
  signal Z_IM_PREV : signed(N_BITS+1-1 downto 0);
  signal Z_IM_CURR : signed(N_BITS+1-1 downto 0);
  signal Z_IM_NEXT : signed(N_BITS+1-1 downto 0);

  -- Norm(Z) --
  signal Z_NORM_CURR : signed((N_BITS+5)-1 downto 0);
  signal Z_NORM_NEXT : signed((N_BITS+5)-1 downto 0);

  -- Iteration Number --
  signal ITERxD_PREV : unsigned(MEM_DATA_BW-1 downto 0);
  signal ITERxD_CURR : unsigned(MEM_DATA_BW-1 downto 0);
  signal ITERxD_NEXT : unsigned(MEM_DATA_BW-1 downto 0);

  -- Write enable signal --
  signal WExS : std_logic;

  -- Default norm --
  constant Z_NORM_0 : signed((N_BITS+5)-1 downto 0) :=  resize(shift_right(C_RE_0 * C_RE_0 + C_IM_0 * C_IM_0, N_FRAC), N_BITS+5);
begin

  -- X/Y Loop --
  x_y_loop : process (CLKxCI, RSTxRI)
  begin
    if (RSTxRI = '1') then
      X_PREV <= (others => '0');
      X_CURR <= (others => '0');

      Y_PREV <= (others => '0');
      Y_CURR <= (others => '0');

      C_RE_PREV <= resize(C_RE_0, N_BITS+1);
      C_RE_CURR <= resize(C_RE_0, N_BITS+1);

      C_IM_PREV <= resize(C_IM_0, N_BITS+1);
      C_IM_CURR <= resize(C_IM_0, N_BITS+1);
    elsif (CLKxCI'event and CLKxCI='1') then
      X_PREV <= X_CURR;
      X_CURR <= X_NEXT;

      Y_PREV <= Y_CURR;
      Y_CURR <= Y_NEXT;

      C_RE_PREV <= C_RE_CURR;
      C_RE_CURR <= C_RE_NEXT;
      
      C_IM_PREV <= C_IM_CURR;
      C_IM_CURR <= C_IM_NEXT;
    end if;
  end process x_y_loop;

  -- X/Y Computation --
  x_y_computation : process (all)
  begin
  if (WExS='1') then
    if (X_CURR=HS_DISPLAY-1) then
      X_NEXT <= (others => '0');
    else
      X_NEXT <= X_CURR+1;
    end if;
  else
    X_NEXT <= X_CURR;
  end if;

  if (WExS='1') then
    if (Y_CURR=VS_DISPLAY-1) and (X_CURR=HS_DISPLAY-1) then
      Y_NEXT <= (others => '0');
    elsif (X_CURR=HS_DISPLAY-1) then
      Y_NEXT <= Y_CURR+1;
    else 
      Y_NEXT <= Y_CURR;
    end if;
  else
    Y_NEXT <= Y_CURR;
  end if;
  end process x_y_computation;
  
  -- C Computation --
  c_computation : process (all)
  begin
  if (WExS='1') then
    if (X_CURR=HS_DISPLAY-1) then
      C_RE_NEXT <= resize(C_RE_0, N_BITS+1);
    else
      C_RE_NEXT <= C_RE_CURR + C_RE_INC;
    end if;
  else
    C_RE_NEXT <= C_RE_CURR;
  end if;

  if (WExS='1') then
    if (Y_CURR=VS_DISPLAY-1) then
      C_IM_NEXT <= resize(C_IM_0, N_BITS+1);
    elsif (X_CURR=HS_DISPLAY-1) then
      C_IM_NEXT <= C_IM_CURR + C_IM_INC;
    else 
      C_IM_NEXT <= C_IM_CURR;
    end if;
  else
    C_IM_NEXT <= C_IM_CURR;
  end if;
  end process c_computation;

  -- Iteration loop --
  conv_loop : process (CLKxCI, RSTxRI)
  begin
    if (RSTxRI = '1') then
      Z_RE_PREV <= resize(C_RE_0, N_BITS+1);
      Z_RE_CURR <= resize(C_RE_0, N_BITS+1);

      Z_IM_PREV <= resize(C_IM_0, N_BITS+1);
      Z_IM_CURR <= resize(C_IM_0, N_BITS+1);

      Z_NORM_CURR <= Z_NORM_0;

      ITERxD_PREV <= (others => '0');
      ITERxD_CURR <= (others => '0');

      WExS <= '0';
    elsif (CLKxCI'event and CLKxCI='1') then
      Z_RE_PREV <= Z_RE_CURR;
      Z_RE_CURR <= Z_RE_NEXT;

      Z_IM_PREV <= Z_IM_CURR;
      Z_IM_CURR <= Z_IM_NEXT;

      Z_NORM_CURR <= Z_NORM_NEXT;
      
      ITERxD_PREV <= ITERxD_CURR;
      ITERxD_CURR <= ITERxD_NEXT;

      WExS <= '0' when ((Z_NORM_CURR < 4*(2**N_FRAC)) and (ITERxD_CURR < MAX_ITER)) else '1';
    end if;
  end process conv_loop;
  
  -- Re(z), Im(z) computation -- 
  z_computation : process (all)
  begin
    if (WExS = '0') then
      if (Z_NORM_CURR < 4*(2**N_FRAC) and
          ITERxD_CURR < MAX_ITER) then
        Z_RE_NEXT <= resize(shift_right(Z_RE_CURR * Z_RE_CURR - Z_IM_CURR * Z_IM_CURR + C_RE_CURR*(2**N_FRAC), N_FRAC), N_BITS+1);
        Z_IM_NEXT <= resize(shift_right(2 * Z_RE_CURR * Z_IM_CURR + C_IM_CURR*(2**N_FRAC), N_FRAC), N_BITS+1);
        Z_NORM_NEXT <= resize(shift_right(Z_RE_CURR * Z_RE_CURR + Z_IM_CURR * Z_IM_CURR, N_FRAC), N_BITS+5);
      else
        Z_RE_NEXT <= Z_RE_CURR;
        Z_IM_NEXT <= Z_IM_CURR;
        Z_NORM_NEXT <= Z_NORM_CURR;
      end if;
    else
      Z_RE_NEXT <= C_RE_NEXT;
      Z_IM_NEXT <= C_IM_NEXT;
      Z_NORM_NEXT <= resize(shift_right(C_RE_NEXT * C_RE_NEXT + C_IM_NEXT * C_IM_NEXT, N_FRAC), N_BITS+5);
    end if;
  end process z_computation;

  -- Next iteration computation -- 
  iter_computation : process (all)
  begin
    if (WExS = '0') then
      if (Z_NORM_CURR < 4*(2**N_FRAC) and
          ITERxD_CURR < MAX_ITER) then
        ITERxD_NEXT <= ITERxD_CURR + 1;
      else
        ITERxD_NEXT <= ITERxD_CURR;
      end if;
    else
      ITERxD_NEXT <= (others => '0');
    end if;
  end process iter_computation;

  -- Outputs --
  XxDO <= X_CURR;
  YxDO <= Y_CURR;
  WExSO <= WExS;
  ITERxDO <= ITERxD_PREV;

end architecture rtl;
--=============================================================================
-- ARCHITECTURE END
--=============================================================================
