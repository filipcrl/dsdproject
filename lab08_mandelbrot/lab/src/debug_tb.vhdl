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
    --signal DEBUG_CRxD : signed(N_BITS - 1 downto 0);
    --signal DEBUG_CMxD : signed(N_BITS - 1 downto 0);
    --signal DEBUG_ZRxD : signed(N_BITS - 1 downto 0);
    --signal DEBUG_ZMxD : signed(N_BITS - 1 downto 0);
    signal ITERxD : unsigned(MEM_DATA_BW-1 downto 0);
    --signal OVERFLOW : std_logic;

    component mandelbrot is
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
    end component;

begin

    M1: mandelbrot
        port map (
            CLKxCI => clk,
            RSTxRI => reset,
            WExSO => WExS,
            XxDO => XxD,
            YxDO => YxD,
            --DEBUG_CRxDO => DEBUG_CRxD,
            --DEBUG_CMxDO => DEBUG_CMxD,
            --DEBUG_ZRxDO => DEBUG_ZRxD,
            --DEBUG_ZMxDO => DEBUG_ZMxD,
            ITERxDO => ITERxD
            --DEBUG_OVERFLOW => OVERFLOW
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
    
    
                -- report "reset = " & to_string(reset);
            report "clk = " & to_string(clk);
            report "WExSO = " & to_string(WExS);
            report "XxD0 = " & to_string(XxD);
            report "YxD0 = " & to_string(YxD);
                --report "DEBUG_CRxDO = " & to_string(DEBUG_CRxD);
                --report "DEBUG_CMxDO = " & to_string(DEBUG_CMxD);
                --report "DEBUG_ZRxDO = " & to_string(DEBUG_ZRxD);
                --report "DEBUG_ZMxDO = " & to_string(DEBUG_ZMxD);
            report "ITERxDO = " & to_string(ITERxD);
                --report "DEBUG_OVERFLOW = " & to_string(OVERFLOW);
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
