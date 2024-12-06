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

    -- Controls from push buttons
    LeftxSI  : in std_logic;
    RightxSI : in std_logic;

    -- Coordinate from VGA
    VgaXxDI : in unsigned(COORD_BW - 1 downto 0);
    VgaYxDI : in unsigned(COORD_BW - 1 downto 0);

    -- Signals from video interface to synchronize (HIGH for 1 CC, when vertical sync starts)
    VSEdgexSI : in std_logic;

    -- Ball and plate coordinates
    BallXxDO  : out unsigned(COORD_BW - 1 downto 0);
    BallYxDO  : out unsigned(COORD_BW - 1 downto 0);
    PlateXxDO : out unsigned(COORD_BW - 1 downto 0)
    
     -- VGA coordinates colors
     VgaXxDI : in unsigned(COORD_BW - 1 downto 0); -- Current VGA X coordinate
     VgaYxDI : in unsigned(COORD_BW - 1 downto 0); -- Current VGA Y coordinate
    
    -- VGA color output
     VgaColor : out std_logic_vector(2 downto 0) 
  );
end pong_fsm;
-- TODO: Implement your code here

architecture rtl of pong_fsm is
-- Constants
  constant SCREEN_WIDTH  : integer := x;               -- Screen width
  constant SCREEN_HEIGHT : integer := y;               -- Screen height
  constant BALL_SIZE     : integer := 10;                -- Ball size
  constant PLATE_WIDTH   : integer := 80;                -- Plate width
  constant PLATE_HEIGHT  : integer := 10;                -- Plate height
  constant BALL_SPEED    : integer := 1;                 -- Ball movementN_HEIGHT / 2, COORD_BW); -- Ball Y position
  constant PLATE_SPEED   : integer := 4;                 -- Plate movement speed

  -- Signals for game state
  signal BallX   : unsigned(COORD_BW - 1 downto 0) := to_unsigned(SCREEN_WIDTH / 2, COORD_BW); -- Ball X pos
  signal BallY   : unsigned(COORD_BW - 1 downto 0) := to_unsigned(SCREEN_WIDTH / 2, COORD_BW); -- ball Y pos
--=============================================================================
  signal BallDirX : integer := 1;                        -- Ball x dir
  signal BallDirY : integer := 1;                        -- Ball y dir
  signal PlateX  : unsigned(COORD_BW - 1 downto 0) := to_unsigned((SCREEN_WIDTH - PLATE_WIDTH) / 2, COORD_BW); -- Plate X position
  signal PlateY  : unsigned(COORD_BW - 1 downto 0) := to_unsigned((SCREEN_WIDTH - PLATE_WIDTH) / 2, COORD_BW); -- Plate Y position
--=============================================================================
-- ARCHITECTURE BEGIN
--=============================================================================
begin
process(clk, reset)
    begin
-- TODO: Implement your code here
 if RSTxRI = '1' then
      -- Reset positions middle of the screen
      BallX <= to_unsigned(SCREEN_WIDTH / 2, COORD_BW);
      BallY <= to_unsigned(SCREEN_HEIGHT / 2, COORD_BW);
      BallDirX <= 1;
      BallDirY <= 1;
      PlateX <= to_unsigned((SCREEN_WIDTH - PLATE_WIDTH) / 2, COORD_BW);
  elsif rising_edge(CLKxCI) then
      if VSEdgexSI = '1' then
        -- Ball movement 
        BallX <= BallX + to_unsigned(BALL_SPEED * BallDirX, COORD_BW);
        BallY <= BallY + to_unsigned(BALL_SPEED * BallDirY, COORD_BW);

        -- Ball deflection with vertical walls
        if BallY <= to_unsigned(0, COORD_BW) or BallY >= to_unsigned(SCREEN_HEIGHT - BALL_SIZE, COORD_BW) then
          BallDirY <= -BallDirY; -- deflect
        end if;
        
        -- Ball deflection with horizontal walls
         if BallX <= to_unsigned(0, COORD_BW) or BallX >= to_unsigned(SCREEN_HEIGHT - BALL_SIZE, COORD_BW) then
          BallDirX <= -BallDirX; -- deflect
        end if;
        

        -- Ball collision with paddle
        if BallY >= to_unsigned(SCREEN_HEIGHT - PLATE_HEIGHT - BALL_SIZE, COORD_BW) and
           BallX + to_unsigned(BALL_SIZE, COORD_BW) >= PlateX and
           BallX <= PlateX + to_unsigned(PLATE_WIDTH, COORD_BW) then
          BallDirY <= -BallDirY; -- Reverse vertical direction
        end if;

        -- Ball missed paddle
        if BallY > to_unsigned(SCREEN_HEIGHT, COORD_BW) then
          -- Reset 
          BallX <= to_unsigned(SCREEN_WIDTH / 2, COORD_BW);
          BallY <= to_unsigned(SCREEN_HEIGHT / 2, COORD_BW);
          BallDirX <= 1;
          BallDirY <= 1;
        end if;

        -- Plate movement 
        if LeftxSI = '1' and PlateX > to_unsigned(0, COORD_BW) then
          PlateX <= PlateX - to_unsigned(PLATE_SPEED, COORD_BW); -- Move paddle left
        elsif RightxSI = '1' and PlateX < to_unsigned(SCREEN_WIDTH - PLATE_WIDTH, COORD_BW) then
          PlateX <= PlateX + to_unsigned(PLATE_SPEED, COORD_BW); -- Move paddle right
        end if;
      end if;
    end if;
  end process;

--=============================================================================
-- ARCHITECTURE END
--=============================================================================

 
  -- Graphics 
  process (VgaXxDI, VgaYxDI, BallX, BallY, PlateX)
  begin
    VgaColor <= "000"; --  backgrd color black

    --  Ball (Red)
    if (VgaXxDI >= BallX and VgaXxDI < BallX + to_unsigned(BALL_SIZE, COORD_BW)) and
       (VgaYxDI >= BallY and VgaYxDI < BallY + to_unsigned(BALL_SIZE, COORD_BW)) then
      VgaColor <= "100"; -- Ball color red

    --  Plate (Blue)
    elsif (VgaXxDI >= PlateX and VgaXxDI < PlateX + to_unsigned(PLATE_WIDTH, COORD_BW)) and
          (VgaYxDI >= PlateY and VgaYxDI < PlateY + to_unsigned(PLATE_HEIGHT, COORD_BW)) then
      VgaColor <= "001"; -- Plate color blue
    end if;
  end process;
  
  -- Output psoitions
  BallXxDO <= BallX;  
  BallYxDO <= BallY;  
  PlateXxDO <= PlateX; 

end rtl;