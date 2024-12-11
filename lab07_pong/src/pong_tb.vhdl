library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.dsd_prj_pkg.all;

entity pong_tb is end pong_tb;

architecture tb of pong_tb is
	signal clk : std_logic := '0';
	signal reset : std_logic := '0';

	signal LeftxS : std_logic;
	signal RightxS : std_logic;
	signal VgaXxD : unsigned(COORD_BW - 1 downto 0);
	signal VgaYxD : unsigned(COORD_BW - 1 downto 0);
	signal VSEdgexS : std_logic;
	signal BallXxD : unsigned(COORD_BW - 1 downto 0);
	signal BallYxD : unsigned(COORD_BW - 1 downto 0);
	signal PlateXxD : unsigned(COORD_BW - 1 downto 0);

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
      PlateXxDO : out unsigned(COORD_BW - 1 downto 0)
		);
	end component;
begin
	pong_fsm_0 : pong_fsm
	port map(
		CLKxCI => clk,
		RSTxRI => reset,
		LeftxSI => LeftxS,
		RightxSI => RightxS,
		VgaXxDI => VgaXxD,
		VgaYxDI => VgaYxD,
		VSEdgexSI => VSEdgexS,
		BallXxDO => BallXxD,
		BallYxDO => BallYxD,
		PlateXxDO => PlateXxD
	);

	reset_process : process
	begin
		reset <= '1';
		wait for 100 ns;
		reset <= '0';
		wait;
	end process reset_process;

  movement_process : process
  begin
    while true loop
      RightxS <= '1';
      LeftxS <= '0';
      wait for 100 us;
      RightxS <= '0';
      LeftxS <= '0';
      wait for 100 ns;
      RightxS <= '0';
      LeftxS <= '1';
      wait for 100 us;
    end loop;
  end process movement_process;

	debug_process : process
	begin
		while true loop
			report "clk = " & to_string(clk);
			report "BallXxD = " & integer'image(to_integer(BallXxD));
			report "BallYxD = " & integer'image(to_integer(BallYxD));
			report "PlateXxDO = " & integer'image(to_integer(PlateXxD));
			report "=======";
			wait for 13 ns;
		end loop;
	end process debug_process;

	clk_process : process
	begin
		while true loop
			clk <= '0';
			wait for 13 ns;
			clk <= '1';
			wait for 13 ns;
		end loop;
	end process clk_process;

  vsedge_process : process(clk, reset)
    variable counter : integer range 0 to 5 := 0;
  begin
    if reset = '1' then
      VSEdgexS <= '0';
      counter := 0;
    elsif rising_edge(clk) then
      if counter = 5 then
        VSEdgexS <= '1';
        counter := 0;
      else
        VSEdgexS <= '0';
        counter := counter + 1;
      end if;
    end if;
  end process vsedge_process;
end architecture tb;
