-- Standard library
library ieee;
-- Standard packages
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Packages
library work;
use work.dsd_prj_pkg.all;

entity compositor is
  port (
    CLKxCI : in std_logic;
    RSTxRI : in std_logic;

    XCoordxDI : in unsigned(COORD_BW - 1 downto 0);
    YCoordxDI : in unsigned(COORD_BW - 1 downto 0);

    BallXxDI   : in unsigned(COORD_BW - 1 downto 0);
    BallYxDI   : in unsigned(COORD_BW - 1 downto 0);
		PlateXxDI  : in unsigned(COORD_BW - 1 downto 0)

    BgDOutxDI : in std_logic_vector(MEM_ADDR_BW - 1);

    RedxSI : in std_logic_vector(COLOR_BW - 1 downto 0);
    GreenxSI : in std_logic_vector(COLOR_BW - 1 downto 0);
    BluexSI : in std_logic_vector(COLOR_BW - 1 downto 0);
  );
end entity compositor;

architecture rtl of compositor is

end architecture rtl;
