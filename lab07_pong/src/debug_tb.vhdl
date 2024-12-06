library ieee;
-- Standard packages
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Packages
library work;
use work.dsd_prj_pkg.all;

entity test_bench is

end test_bench;

architecture behaviour of test_bench is
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';

    signal LeftxS  : std_logic;
    signal RightxS : std_logic;
    signal VgaXxD : unsigned(COORD_BW - 1 downto 0);
    signal VgaYxD : unsigned(COORD_BW - 1 downto 0);
    signal VSEdgexS : std_logic;
    signal BallXxD  : unsigned(COORD_BW - 1 downto 0);
    signal BallYxD  : unsigned(COORD_BW - 1 downto 0);
    signal PlateXxD : unsigned(COORD_BW - 1 downto 0);
    signal VgaColXxD : std_logic_vector(2 downto 0);

    component pong_fsm is
        port (
          CLKxCI : in std_logic;
          RSTxRI : in std_logic;
          LeftxSI  : in std_logic;
          RightxSI : in std_logic;
          VgaXxDI : in unsigned(COORD_BW - 1 downto 0);
          VgaYxDI : in unsigned(COORD_BW - 1 downto 0);
          VSEdgexSI : in std_logic;
          BallXxDO  : out unsigned(COORD_BW - 1 downto 0);
          BallYxDO  : out unsigned(COORD_BW - 1 downto 0);
          PlateXxDO : out unsigned(COORD_BW - 1 downto 0);
          VgaColXxDO : out std_logic_vector(2 downto 0) 
        );
    end component;
begin
    M1: pong_fsm
        port map (
            CLKxCI => clk,
            RSTxRI => reset,
            LeftxSI => LeftxS,
            RightxSI => RightxS,
            VgaXxDI => VgaXxD,
            VgaYxDI => VgaYxD,
            VSEdgexSI => VSEdgexS,
            BallXxDO => BallXxD,
            BallYxDO => BallYxD,
            PlateXxDO => PlateXxD,
            VgaColXxDO => VgaColXxD 
        );

    reset_process : process
    begin
        reset <= '1';
        wait for 1 us;
        reset <= '0';
        wait;
    end process reset_process;
   
    debug_process : process
    begin
        VSEdgexS <= '1';
        while true loop
            report "clk = " & to_string(clk);
            report "BallXxD = " & integer'image(to_integer(BallXxD));
            report "BallYxD = " & integer'image(to_integer(BallYxD));
            --report "PlateXxDO = " & integer'image(to_integer(PlateXxD));
            report "=======";
            wait for 10 us;
        end loop;
    end process debug_process;

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 us;
            clk <= '1';
            wait for 10 us;
        end loop;
    end process clk_process;
end behaviour;
