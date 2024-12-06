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
  -- Constants --
  constant SCREEN_WIDTH  : integer := 256;
  constant SCREEN_HEIGHT : integer := 192;

  constant START_X : unsigned(COORD_BW-1 downto 0) 
    := to_unsigned(SCREEN_WIDTH / 2, COORD_BW); 
  constant START_Y : unsigned(COORD_BW-1 downto 0) 
    := to_unsigned(SCREEN_HEIGHT / 2, COORD_BW); 

  constant MIN_X : unsigned(COORD_BW-1 downto 0) 
    := to_unsigned(BALL_WIDTH / 2, COORD_BW); 
  constant MAX_X : unsigned(COORD_BW-1 downto 0) 
    := to_unsigned(SCREEN_WIDTH - BALL_WIDTH / 2, COORD_BW); 
  constant MIN_Y : unsigned(COORD_BW-1 downto 0) 
    := to_unsigned(BALL_WIDTH / 2, COORD_BW); 
  constant MAX_Y : unsigned(COORD_BW-1 downto 0) 
    := to_unsigned(SCREEN_HEIGHT - BALL_WIDTH / 2, COORD_BW); 
    
  -- Signals for game state
  signal BallXxDP, BallXxDN : unsigned(COORD_BW - 1 downto 0);
  signal BallYxDP, BallYxDN : unsigned(COORD_BW - 1 downto 0);
  
  -- Ball direction --
  signal BallDirXxDP, BallDirXxDN : std_logic;
  signal BallDirYxDP, BallDirYxDN : std_logic;

  -- Plate position --
  signal PlateX, PlateY : unsigned(COORD_BW - 1 downto 0);
begin
  -- Ball Movement --
  process(all)
  begin
    BallXxDN <= BallXxDP;
    BallDirXxDN <= BallDirXxDP;
    if (VSEdgexSI = '1') then
      if (BallDirXxDP='1') then
        BallXxDN <= unsigned( signed(BallXxDP) + BALL_STEP_X );
        if (unsigned( signed(BallXxDP) + BALL_STEP_X ) >= MAX_X) then
          BallXxDN <= MAX_X;
          BallDirXxDN <= NOT BallDirXxDP;
        end if;
      else
        BallXxDN <= unsigned( signed(BallXxDP) - BALL_STEP_X );
        if (unsigned( signed(BallXxDP) - BALL_STEP_X ) <= MIN_X) then
          BallXxDN <= MIN_X;
          BallDirXxDN <= NOT BallDirXxDP;
        end if;
      end if;
    end if;

    BallYxDN <= BallYxDP;
    BallDirYxDN <= BallDirYxDP;
    if (VSEdgexSI = '1') then
      if (BallDirYxDP='1') then
        BallYxDN <= unsigned( signed(BallYxDP) + BALL_STEP_Y );
        if (unsigned( signed(BallYxDP) + BALL_STEP_Y ) >= MAX_Y) then
          BallYxDN <= MAX_Y;
          BallDirYxDN <= NOT BallDirYxDP;
        end if;
      else
        BallYxDN <= unsigned( signed(BallYxDP) - BALL_STEP_Y );
        if (unsigned( signed(BallYxDP) - BALL_STEP_Y ) <= MIN_Y) then
          BallYxDN <= MIN_Y;
          BallDirYxDN <= NOT BallDirYxDP;
        end if;
      end if;
    end if;
  end process;

  process(CLKxCI, RSTxRI)
    begin
    if RSTxRI = '1' then
      BallXxDP <= START_X;
      BallYxDP <= START_Y;

      BallDirXxDP <= '1';
      BallDirYxDP <= '1';
      --PlateX <= to_unsigned((SCREEN_WIDTH - PLATE_WIDTH) / 2, COORD_BW);
    elsif rising_edge(CLKxCI) then
      BallXxDP <= BallXxDN;
      BallYxDP <= BallYxDN;

      BallDirXxDP <= BallDirXxDN;
      BallDirYxDP <= BallDirYxDN;
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

        -- Plate movement 
        --if LeftxSI = '1' and PlateX > to_unsigned(0, COORD_BW) then
        --  PlateX <= PlateX - to_unsigned(PLATE_SPEED, COORD_BW); -- Move paddle left
        --elsif RightxSI = '1' and PlateX < to_unsigned(SCREEN_WIDTH - PLATE_WIDTH, COORD_BW) then
        --  PlateX <= PlateX + to_unsigned(PLATE_SPEED, COORD_BW); -- Move paddle right
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
PlateXxDO <= PlateX; 

end rtl;