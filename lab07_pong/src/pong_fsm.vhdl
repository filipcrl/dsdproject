--=============================================================================
-- @file pong_fsm.vhdl
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

    -- Controls --
    LeftxSI, RightxSI : in std_logic;

    -- Coordinates from VGA --
    VgaXxDI, VgaYxDI : in unsigned(COORD_BW - 1 downto 0);

    -- Signals from video interface to synchronize (HIGH for 1 CC, when vertical sync starts) --
    VSEdgexSI : in std_logic;

    -- Ball and plate coordinates --
    BallXxDO, BallYxDO, PlateXxDO : out unsigned(COORD_BW - 1 downto 0);

    -- VGA color output --
    VgaColXxDO : out std_logic_vector(3-1 downto 0) 
  );
end pong_fsm;
-- TODO: Implement your code here

architecture rtl of pong_fsm is
  -- Display constants --
  constant SCREEN_WIDTH  : integer := 256;
  constant SCREEN_HEIGHT : integer := 192;

  -- Ball Constants --
  constant BALL_START_X : unsigned(COORD_BW-1 downto 0) 
    := to_unsigned(SCREEN_WIDTH / 2, COORD_BW); 
  constant BALL_START_Y : unsigned(COORD_BW-1 downto 0) 
    := to_unsigned(SCREEN_HEIGHT / 2, COORD_BW); 
  constant BALL_MIN_X : unsigned(COORD_BW-1 downto 0) 
    := to_unsigned(BALL_WIDTH / 2, COORD_BW); 
  constant BALL_MAX_X : unsigned(COORD_BW-1 downto 0) 
    := to_unsigned(SCREEN_WIDTH - BALL_WIDTH / 2, COORD_BW); 
  constant BALL_MIN_Y : unsigned(COORD_BW-1 downto 0) 
    := to_unsigned(BALL_WIDTH / 2, COORD_BW); 
  constant BALL_MAX_Y : unsigned(COORD_BW-1 downto 0) 
    := to_unsigned(SCREEN_HEIGHT - BALL_WIDTH / 2, COORD_BW); 

  -- Plate constants --
  constant PLATE_START_X : unsigned(COORD_BW-1 downto 0) 
    := to_unsigned(SCREEN_WIDTH / 2, COORD_BW); 
  constant PLATE_START_Y : unsigned(COORD_BW-1 downto 0) 
    := to_unsigned(PLATE_HEIGHT / 2, COORD_BW); 
  constant PLATE_MIN_X : unsigned(COORD_BW-1 downto 0) 
    := to_unsigned(PLATE_WIDTH / 2, COORD_BW); 
  constant PLATE_MAX_X : unsigned(COORD_BW-1 downto 0) 
    := to_unsigned(SCREEN_WIDTH - PLATE_WIDTH / 2, COORD_BW); 
    
  -- Signals for game state
  signal BallXxDP, BallXxDN : unsigned(COORD_BW - 1 downto 0);
  signal BallYxDP, BallYxDN : unsigned(COORD_BW - 1 downto 0);
  
  -- Ball direction --
  signal BallDirXxDP, BallDirXxDN : std_logic;
  signal BallDirYxDP, BallDirYxDN : std_logic;

  -- Plate position --
  signaL PlateXxDP, PlateXxDN : unsigned(COORD_BW - 1 downto 0);
begin
  -- Ball Movement --
  process(all)
  begin
    BallXxDN <= BallXxDP;
    BallDirXxDN <= BallDirXxDP;
    if (VSEdgexSI = '1') then
      if (BallDirXxDP='1') then
        BallXxDN <= unsigned( signed(BallXxDP) + BALL_STEP_X );
        if (signed(BallXxDP) + BALL_STEP_X >= signed(BALL_MAX_X)) then
          BallXxDN <= BALL_MAX_X;
          BallDirXxDN <= NOT BallDirXxDP;
        end if;
      else
        BallXxDN <= unsigned( signed(BallXxDP) - BALL_STEP_X );
        if (signed(BallXxDP) - BALL_STEP_X <= signed(BALL_MIN_X)) then
          BallXxDN <= BALL_MIN_X;
          BallDirXxDN <= NOT BallDirXxDP;
        end if;
      end if;
    end if;

    BallYxDN <= BallYxDP;
    BallDirYxDN <= BallDirYxDP;
    if (VSEdgexSI = '1') then
      if (BallDirYxDP='1') then
        BallYxDN <= unsigned( signed(BallYxDP) + BALL_STEP_Y );
        if (signed(BallYxDP) + BALL_STEP_Y >= signed(BALL_MAX_Y)) then
          BallYxDN <= BALL_MAX_Y;
          BallDirYxDN <= NOT BallDirYxDP;
        end if;
      else
        BallYxDN <= unsigned( signed(BallYxDP) - BALL_STEP_Y );
        if (signed(BallYxDP) - BALL_STEP_Y <= signed(BALL_MIN_Y)) then
          BallYxDN <= BALL_MIN_Y;
          BallDirYxDN <= NOT BallDirYxDP;
        end if;
      end if;
    end if;
  end process;
  
  -- Plate Mouvement --
  process(all)
  begin
    PlateXxDN <= PlateXxDP;
    if (VSEdgexSI = '1') then
      if (RightxSI = '1') then
        PlateXxDN <= unsigned( signed(PlateXxDP) + PLATE_STEP_X );
        if (signed(PlateXxDP) + PLATE_STEP_X >= signed(PLATE_MAX_X)) then
          PlateXxDN <= PLATE_MAX_X;
        end if;
      end if;
      if (LeftxSI = '1') then
        PlateXxDN <= unsigned( signed(PlateXxDP) - PLATE_STEP_X );
        if (signed(PlateXxDP) - PLATE_STEP_X <= signed(PLATE_MIN_X)) then
          PlateXxDN <= PLATE_MIN_X;
        end if;
      end if;
    end if;
  end process;

  process(CLKxCI, RSTxRI)
    begin
    if RSTxRI = '1' then
      BallXxDP <= BALL_START_X;
      BallYxDP <= BALL_START_Y;

      BallDirXxDP <= '1';
      BallDirYxDP <= '1';

      PlateXxDP <= PLATE_START_X;
    elsif rising_edge(CLKxCI) then
      BallXxDP <= BallXxDN;
      BallYxDP <= BallYxDN;

      BallDirXxDP <= BallDirXxDN;
      BallDirYxDP <= BallDirYxDN;

      PlateXxDP <= PlateXxDN;
        -- Ball collision with paddle
        --if BallY >= to_unsigned(SCREEN_HEIGHT - PLATE_HEIGHT - BALL_WIDTH, COORD_BW) and
        --   BallX + to_unsigned(BALL_WIDTH, COORD_BW) >= PlateX and
        --   BallX <= PlateX + to_unsigned(PLATE_WIDTH, COORD_BW) then
        --  BallDirY <= -BallDirY; -- Reverse vertical direction
        --end if;

        -- Ball missed paddle
        --if BallY > to_unsigned(SCREEN_HEIGHT, COORD_BW) then
          -- Reset 
        --  BallX <= to_unsigned(SCREEN_WIDTH / 2, COORD_BW);
        --  BallY <= to_unsigned(SCREEN_HEIGHT / 2, COORD_BW);
        --  BallDirX <= 1;
        --  BallDirY <= 1;
        --end if;
    end if;
  end process;

--=============================================================================
-- ARCHITECTURE END
--=============================================================================

 
-- Graphics 
--  process (VgaXxDI, VgaYxDI, BallX, BallY, PlateX)
--  begin
--    VgaColXxDO <= "000"; --  backgrd color black

    --  Ball (Red)
--    if (VgaXxDI >= BallX and VgaXxDI < BallX + to_unsigned(BALL_WIDTH, COORD_BW)) and
--       (VgaYxDI >= BallY and VgaYxDI < BallY + to_unsigned(BALL_WIDTH, COORD_BW)) then
--      VgaColXxDO <= "100"; -- Ball color red

    --  Plate (Blue)
--   elsif (VgaXxDI >= PlateX and VgaXxDI < PlateX + to_unsigned(PLATE_WIDTH, COORD_BW)) and
--          (VgaYxDI >= PlateY and VgaYxDI < PlateY + to_unsigned(PLATE_HEIGHT, COORD_BW)) then
--      VgaColXxDO <= "001"; -- Plate color blue
--    end if;
--  end process;
  
  -- Output psoitions
BallXxDO <= BallXxDP;  
BallYxDO <= BallYxDP;  
PlateXxDO <= PlateXxDP; 

end rtl;