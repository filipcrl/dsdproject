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

    signal WExS : std_logic;
    signal XxD : unsigned(COORD_BW - 1 downto 0);
    signal YxD : unsigned(COORD_BW - 1 downto 0);
    signal ITERxD : unsigned(MEM_DATA_BW-1 downto 0);

    component mandelbrot is
        port (
            CLKxCI : in std_logic;
            RSTxRI : in std_logic;
            WExSO   : out std_logic;
            XxDO    : out unsigned(COORD_BW - 1 downto 0);
            YxDO    : out unsigned(COORD_BW - 1 downto 0);
            ITERxDO   : out unsigned(MEM_DATA_BW-1 downto 0)
        );
    end component;

begin

    M1: mandelbrot
        port map (
            CLKxCI => clk,
            RSTxRI => reset,
            WExSO => WExS,
            XxDO => XxD,
            YxDO => YxD,
            ITERxDO => ITERxD
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
        while true loop
            --if (WExS = '1') then
                report "clk = " & to_string(clk);
                report "WExSO = " & to_string(WExS);
                report "XxDO = " & integer'image(to_integer(XxD));
                report "YxD0 = " & integer'image(to_integer(YxD));
                report "ITERxDO = " & integer'image(to_integer(ITERxD));
                report "=======";
            --end if;
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
