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
-- pong_fsm
--
-- @brief This file specifies a basic circuit for the pong game. Note that coordinates are counted
-- from the upper left corner of the screen.
--
--=============================================================================

--=============================================================================
-- ENTITY DECLARATION FOR PONG_FSM
--=============================================================================

entity pong_fsm is
	port (
		CLKxCI : in std_logic;
		RSTxRI : in std_logic;

		-- Controls from push buttons
		LeftxSI : in std_logic;
		RightxSI : in std_logic;

		-- Coordinate from VGA
		VgaXxDI : in unsigned(COORD_BW - 1 downto 0);
		VgaYxDI : in unsigned(COORD_BW - 1 downto 0);

		-- Signals from video interface to synchronize (HIGH for 1 CC, when vertical sync starts)
		VSEdgexSI : in std_logic;

		-- Ball and plate coordinates
		BallXxDO : out unsigned(COORD_BW - 1 downto 0);
		BallYxDO : out unsigned(COORD_BW - 1 downto 0);
		PlateXxDO : out unsigned(COORD_BW - 1 downto 0)
	);
end pong_fsm;

architecture rtl of pong_fsm is
	-- Ball Constants --
	constant BALL_START_X : unsigned(COORD_BW - 1 downto 0)
	 := to_unsigned(HS_DISPLAY / 2, COORD_BW);
	constant BALL_START_Y : unsigned(COORD_BW - 1 downto 0)
	 := to_unsigned(VS_DISPLAY / 2, COORD_BW);
	constant BALL_MIN_X : unsigned(COORD_BW - 1 downto 0)
	 := to_unsigned(BALL_WIDTH / 2, COORD_BW);
	constant BALL_MAX_X : unsigned(COORD_BW - 1 downto 0)
	 := to_unsigned(HS_DISPLAY - BALL_WIDTH / 2, COORD_BW);
	constant BALL_MIN_Y : unsigned(COORD_BW - 1 downto 0)
	 := to_unsigned(BALL_WIDTH / 2, COORD_BW);
	constant BALL_MAX_Y : unsigned(COORD_BW - 1 downto 0)
	 := to_unsigned(VS_DISPLAY - BALL_WIDTH / 2, COORD_BW);

	-- Plate constants --
	constant PLATE_START_X : unsigned(COORD_BW - 1 downto 0)
	 := to_unsigned(HS_DISPLAY / 2, COORD_BW);
	constant PLATE_START_Y : unsigned(COORD_BW - 1 downto 0)
	 := to_unsigned(PLATE_HEIGHT / 2, COORD_BW);
	constant PLATE_MIN_X : unsigned(COORD_BW - 1 downto 0)
	 := to_unsigned(PLATE_WIDTH / 2, COORD_BW);
	constant PLATE_MAX_X : unsigned(COORD_BW - 1 downto 0)
	 := to_unsigned(HS_DISPLAY - PLATE_WIDTH / 2, COORD_BW);

	signal BallXxDP, BallXxDN : unsigned(COORD_BW - 1 downto 0);
	signal BallYxDP, BallYxDN : unsigned(COORD_BW - 1 downto 0);
	signal BallXNextxD, BallYNextxD : unsigned(COORD_BW - 1 downto 0);
	signal PlateXxDP, PlateXxDN : unsigned(COORD_BW - 1 downto 0);
	signal PlateXNextxD : unsigned(COORD_BW - 1 downto 0);

	signal BallDirXxDP, BallDirXxDN : std_logic;
	signal BallDirYxDP, BallDirYxDN : std_logic;
begin
	BallXNextxD <= BallXxDP + BALL_STEP_X when BallDirXxDP = '1'
		else BallXxDP - BALL_STEP_X;

	BallYNextxD <= BallYxDP + BALL_STEP_Y when BallDirYxDP = '1'
		else BallYxDP - BALL_STEP_Y;

	PlateXNextxD <= PlateXxDP + PLATE_STEP_X when RightxSI = '1' else
		PlateXxDP - PLATE_STEP_X when LeftxSI else
		PlateXxDP;

	process (all)
	begin
		BallXxDN <= BallXxDP;
		BallDirXxDN <= BallDirXxDP;

		BallYxDN <= BallYxDP;
		BallDirYxDN <= BallDirYxDP;

		PlateXxDN <= PlateXxDP;

		if (VSEdgexSI = '1') then
			-- Advance ball and plate
			BallXxDN <= BallXNextxD;
			BallYxDN <= BallYNextxD;
			PlateXxDN <= PlateXNextxD;

			-- Right bounce
			if (BallXNextxD >= BALL_MAX_X) then
				BallXxDN <= BALL_MAX_X;
				BallDirXxDN <= not BallDirXxDP;
			end if;

			-- Left bounce
			if (BallXNextxD <= BALL_MIN_X) then
				BallXxDN <= BALL_MIN_X;
				BallDirXxDN <= not BallDirXxDP;
			end if;

			-- Top bounce
			if (BallYNextxD <= BALL_MIN_Y) then
				BallYxDN <= BALL_MIN_Y;
				BallDirYxDN <= not BallDirYxDP;
			end if;

			-- Plate right clamp
			if (PlateXNextxD >= PLATE_MAX_X) then
				PlateXxDN <= PLATE_MAX_X;
			end if;

			-- Plate left clamp
			if (PlateXNextxD <= PLATE_MIN_X) then
				PlateXxDN <= PLATE_MIN_X;
			end if;

			-- Ball plate bounce
			if (BallYNextxD >= VS_DISPLAY - PLATE_HEIGHT - BALL_HEIGHT / 2) and
				(BallXNextxD + BALL_WIDTH / 2 >= PlateXxDP - PLATE_WIDTH / 2) and
				(BallXNextxD - BALL_WIDTH / 2 <= PlateXxDP + PLATE_WIDTH / 2) then
				BallDirYxDN <= not BallDirYxDP;
			end if;

			-- Ball lost
			if (BallYNextxD > VS_DISPLAY) then
				BallXxDN <= BALL_START_X;
				BallYxDN <= BALL_START_Y;
				BallDirXxDN <= '1';
				BallDirYxDN <= '1';
			end if;
		end if;
	end process;

	process (CLKxCI, RSTxRI)
	begin
		if RSTxRI = '1' then
			BallXxDP <= BALL_START_X;
			BallYxDP <= BALL_START_Y;

			BallDirXxDP <= '1';
			BallDirYxDP <= '1';

			PlateXxDP <= PLATE_START_X;
		elsif CLKxCI'event and CLKxCI = '1' then
			BallXxDP <= BallXxDN;
			BallYxDP <= BallYxDN;

			BallDirXxDP <= BallDirXxDN;
			BallDirYxDP <= BallDirYxDN;

			PlateXxDP <= PlateXxDN;
		end if;
	end process;

	-- Output positions
	BallXxDO <= BallXxDP;
	BallYxDO <= BallYxDP;
	PlateXxDO <= PlateXxDP;
end rtl;
--=============================================================================
-- ARCHITECTURE END
--=============================================================================
