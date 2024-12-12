--=============================================================================
-- @file compositor.vhdl
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
-- ENTITY DECLARATION FOR COMPOSITOR
--=============================================================================
entity compositor is
	port (
		CLKxCI     : in std_logic;
		RSTxRI     : in std_logic;

		VSEdgexSI  : in std_logic;

		-- VGA coordinates
		XCoordxDI  : in unsigned(COORD_BW - 1 downto 0);
		YCoordxDI  : in unsigned(COORD_BW - 1 downto 0);

		-- Ball and plate positions
		BallXxDI   : in unsigned(COORD_BW - 1 downto 0);
		BallYxDI   : in unsigned(COORD_BW - 1 downto 0);
		PlateXxDI  : in unsigned(COORD_BW - 1 downto 0);

		-- Background color data read from memory
		BgDOutxDI  : in std_logic_vector(MEM_DATA_BW - 1 downto 0);

		-- RGB outputs
		RedxSO     : out std_logic_vector(COLOR_BW - 1 downto 0);
		GreenxSO   : out std_logic_vector(COLOR_BW - 1 downto 0);
		BluexSO    : out std_logic_vector(COLOR_BW - 1 downto 0)
	);
end entity compositor;

--=============================================================================
-- ARCHITECTURE DECLARATION
--=============================================================================
architecture rtl of compositor is

	--=============================================================================
	-- SIGNAL DECLARATIONS
	--=============================================================================
	-- Signals for sprite memory
	signal RdAddrSpritexD : std_logic_vector(14 - 1 downto 0);
	signal DOutSpritexD : std_logic_vector(MEM_DATA_BW - 1 downto 0);

	-- Sprite colors
	signal SpriteRedxS : std_logic_vector(COLOR_BW - 1 downto 0);
	signal SpriteGreenxS : std_logic_vector(COLOR_BW - 1 downto 0);
	signal SpriteBluexS : std_logic_vector(COLOR_BW - 1 downto 0);

	-- Background colors
	signal BGRedxS : std_logic_vector(COLOR_BW - 1 downto 0);
	signal BGGreenxS : std_logic_vector(COLOR_BW - 1 downto 0);
	signal BGBluexS : std_logic_vector(COLOR_BW - 1 downto 0);

	-- Drawing flags
	signal DrawBallxS : std_logic;
	signal DrawPlatexS : std_logic;

	-- Animations
	signal SpriteNxDP, SpriteNxDN : unsigned(10 - 1 downto 0);
	signal AnimCntxDP, AnimCntxDN : unsigned(10 - 1 downto 0);

	--=============================================================================
	-- COMPONENT DECLARATIONS
	--=============================================================================
	component blk_mem_gen_1
		port (
			clka   : in std_logic;
			ena    : in std_logic;
			wea    : in std_logic_vector(0 downto 0);
			addra  : in std_logic_vector(14 - 1 downto 0);
			dina   : in std_logic_vector(11 downto 0);
			douta  : out std_logic_vector(11 downto 0)
		);
	end component;

begin
	--=============================================================================
	-- COMPONENT INSTANTIATIONS
	--=============================================================================
	-- Sprite Memory (for ball and plate textures)
	i_blk_mem_gen_1 : blk_mem_gen_1
	port map(
		clka   => CLKxCI, 
		ena    => '1', 
		wea    => (others => '0'), 
		addra  => RdAddrSpritexD, 
		dina   => (others => '0'), 
		douta  => DOutSpritexD
	);

	process (CLKxCI, RSTxRI)
	begin
		if (RSTxRI = '1') then
			SpriteNxDP <= to_unsigned(1, SpriteNxDP'length);
			AnimCntxDP <= (others => '0');
		elsif (CLKxCI'EVENT and CLKxCI = '1') then
			SpriteNxDP <= SpriteNxDN;
			AnimCntxDP <= AnimCntxDN;
		end if;
	end process;

	process (all)
		begin
			AnimCntxDN <= AnimCntxDP;
			SpriteNxDN <= SpriteNxDP;
			if (VSEdgexSI = '1') then
				AnimCntxDN <= AnimCntxDP + 1;

				if (AnimCntxDP = 70) then
					AnimCntxDN <= (others => '0');
          SpriteNxDN <= SpriteNxDP + 1;

          if (SpriteNxDP = 4) then
            SpriteNxDN <= to_unsigned(1, SpriteNxDP'length);
          end if;
				end if;
			end if;
		end process;

		--=============================================================================
		-- SPRITE AND BACKGROUND COLOR EXTRACTION
		--=============================================================================
		-- Extract background colors from memory data
		BGRedxS <= BgDOutxDI(3 * COLOR_BW - 1 downto 2 * COLOR_BW);
		BGGreenxS <= BgDOutxDI(2 * COLOR_BW - 1 downto 1 * COLOR_BW);
		BGBluexS <= BgDOutxDI(1 * COLOR_BW - 1 downto 0 * COLOR_BW);

		-- Extract sprite colors from sprite memory data
		SpriteRedxS <= DOutSpritexD(3 * COLOR_BW - 1 downto 2 * COLOR_BW);
		SpriteGreenxS <= DOutSpritexD(2 * COLOR_BW - 1 downto 1 * COLOR_BW);
		SpriteBluexS <= DOutSpritexD(1 * COLOR_BW - 1 downto 0 * COLOR_BW);

		--=============================================================================
		-- DRAWING LOGIC
		--=============================================================================
		-- Determine if the current pixel is inside the ball
		-- DrawBallxS <= '1' when ((signed(XCoordxDI) - signed(BallXxDI)) * (signed(XCoordxDI) - signed(BallXxDI)) +
		-- (signed(YCoordxDI) - signed(BallYxDI)) * (signed(YCoordxDI) - signed(BallYxDI))) <= (BALL_WIDTH/2)*(BALL_WIDTH/2)
		-- else '0';

		DrawBallxS <= '1' when (XCoordxDI >= BallXxDI - BALL_WIDTH/2) and
		              (XCoordxDI < BallXxDI + BALL_WIDTH/2) and
		              (YCoordxDI >= BallYxDI - BALL_HEIGHT/2) and
		              (YCoordxDI <= BallYxDI + BALL_HEIGHT/2) else '0';

		-- Determine if the current pixel is inside the plate
		DrawPlatexS <= '1' when (XCoordxDI >= PlateXxDI - PLATE_WIDTH/2) and
		               (XCoordxDI < PlateXxDI + PLATE_WIDTH/2) and
		               (YCoordxDI >= VS_DISPLAY - PLATE_HEIGHT) and
		               (YCoordxDI <= VS_DISPLAY)
		               else '0';

		--=============================================================================
		-- SPRITE ADDRESS CALCULATION
		--=============================================================================
		-- Calculate sprite memory address based on current pixel position
		process (all)
    begin
      RdAddrSpritexD <= (others => '0');

      if (DrawBallxS = '1') then
        RdAddrSpritexD <= std_logic_vector(resize(256 * SpriteNxDP + (YCoordxDI - BallYxDI + BALL_HEIGHT/2)/2 * 16 + (XCoordxDI - BallXxDI + BALL_WIDTH/2)/2, RdAddrSpritexD'length));
      elsif (DrawPlatexS = '1') then
        RdAddrSpritexD <= std_logic_vector(resize((YCoordxDI mod 16) * 16 + ((XCoordxDI - PlateXxDI + PLATE_WIDTH/2) mod 16), RdAddrSpritexD'length));
      end if;
    end process;

    --=============================================================================
    -- OUTPUT COLOR ASSIGNMENT
    --=============================================================================
    -- Assign output colors based on drawing flags
    RedxSO <= BGRedxS when DrawBallxS = '1' and SpriteRedxS = "0000" else
              SpriteRedxS when DrawBallxS = '1' else
              SpriteRedxS when DrawPlatexS = '1' else
              BGRedxS;

    GreenxSO <= BGGreenxS when DrawBallxS = '1' and SpriteGreenxS = "0000" else
                SpriteGreenxS when DrawBallxS = '1' else
                SpriteGreenxS when DrawPlatexS = '1' else
                BGGreenxS;

    BluexSO <= BGBluexS when DrawBallxS = '1' and SpriteBluexS = "0000" else
               SpriteBluexS when DrawBallxS = '1' else
               SpriteBluexS when DrawPlatexS = '1' else
               BGBluexS;
end architecture rtl;
