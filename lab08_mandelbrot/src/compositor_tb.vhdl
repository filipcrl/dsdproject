library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library std;
use std.env.stop;
use std.textio.all;
library work;
use work.dsd_prj_pkg.all;

entity compositor_tb is
end compositor_tb;

architecture tb of compositor_tb is
    -- Clock and Reset Signals
    signal ClkxS       : std_logic := '0';
    signal RstxS       : std_logic := '0';

    -- Synchronization Signal
    signal VSEdgexS    : std_logic := '0';

    -- Coordinate Signals
    signal XCoordxD    : unsigned(COORD_BW - 1 downto 0);
    signal YCoordxD    : unsigned(COORD_BW - 1 downto 0);
    signal BallXxD     : unsigned(COORD_BW - 1 downto 0) := to_unsigned(100, COORD_BW);
    signal BallYxD     : unsigned(COORD_BW - 1 downto 0) := to_unsigned(100, COORD_BW);
    signal PlateXxD    : unsigned(COORD_BW - 1 downto 0);

    -- Background Data Output
    signal BgDOutxD    : std_logic_vector(MEM_DATA_BW - 1 downto 0) := (others => '0');

    -- Color Outputs
    signal RedxS       : std_logic_vector(COLOR_BW - 1 downto 0);
    signal GreenxS     : std_logic_vector(COLOR_BW - 1 downto 0);
    signal BluexS      : std_logic_vector(COLOR_BW - 1 downto 0);

    -- Constants for Region Size
    constant REGION_SIZE : integer := 64;
    constant HALF_REGION : integer := REGION_SIZE / 2;

    -- Component Declaration for Compositor
    component compositor is
        port (
            CLKxCI    : in std_logic;
            RSTxRI    : in std_logic;

            VSEdgexSI : in std_logic;

            XCoordxDI : in unsigned(COORD_BW - 1 downto 0);
            YCoordxDI : in unsigned(COORD_BW - 1 downto 0);

            BallXxDI  : in unsigned(COORD_BW - 1 downto 0);
            BallYxDI  : in unsigned(COORD_BW - 1 downto 0);
            PlateXxDI : in unsigned(COORD_BW - 1 downto 0);

            BgDOutxDI : in std_logic_vector(MEM_DATA_BW - 1 downto 0);

            RedxSO    : out std_logic_vector(COLOR_BW - 1 downto 0);
            GreenxSO  : out std_logic_vector(COLOR_BW - 1 downto 0);
            BluexSO   : out std_logic_vector(COLOR_BW - 1 downto 0)
        );
    end component;

begin
    -- Instantiate the Compositor
    i_compositor : compositor
        port map (
            CLKxCI    => ClkxS,
            RSTxRI    => RstxS,

            VSEdgexSI => VSEdgexS,

            XCoordxDI => XCoordxD,
            YCoordxDI => YCoordxD,

            BallXxDI  => BallXxD,
            BallYxDI  => BallYxD,
            PlateXxDI => PlateXxD,

            BgDOutxDI => BgDOutxD,

            RedxSO    => RedxS,
            GreenxSO  => GreenxS,
            BluexSO   => BluexS
        );

    -- Clock Generation Process (25 MHz Clock)
    clk_process : process
    begin
        while true loop
            ClkxS <= '0';
            wait for 20 ns; -- Adjust period as needed (e.g., 20 ns for 50 MHz)
            ClkxS <= '1';
            wait for 20 ns;
        end loop;
    end process clk_process;

    -- Stimulus Process
    stimulus_process : process
        variable red_val   : integer;
        variable green_val : integer;
        variable blue_val  : integer;
        variable red_plate     : integer;
        variable green_plate   : integer;
        variable blue_plate    : integer;

        file output_file : text open write_mode is "ball_output.ppm";
        variable line_buffer : line;
        file output_plate : text open write_mode is "plate.ppm";
        variable line_plate : line;
    begin
        -- Wait for Reset to Deassert
        RstxS <= '1';
        wait for 200 ns; -- Ensure initialization
        RstxS <= '0';

        -- Set Plate Position (Example: Plate centered at X = 100)
        PlateXxD <= to_unsigned(100, COORD_BW);

        -- Write PPM Header
        write(line_buffer, string'("P3"));
        writeline(output_file, line_buffer);
        
        write(line_buffer, string'("64 256"));
        writeline(output_file, line_buffer);
        
        write(line_buffer, string'("255"));
        writeline(output_file, line_buffer);

        write(line_plate, string'("P3"));
        writeline(output_plate, line_plate);
        
        write(line_plate, string'("256 64"));
        writeline(output_plate, line_plate);
        
        write(line_plate, string'("255"));
        writeline(output_plate, line_plate);

        -- Wait before starting capture
        wait for 100 us;

        -- Capture 64x64 Pixel Region Around (100, 100)
        for i in 0 to 3 loop
          for dy in 0 to REGION_SIZE - 1 loop
              for dx in 0 to REGION_SIZE - 1 loop
                  -- Set X and Y Coordinates
                  XCoordxD <= to_unsigned(100 - HALF_REGION + dx, COORD_BW);
                  YCoordxD <= to_unsigned(100 - HALF_REGION + dy, COORD_BW);
                  
                  -- Wait for a Clock Cycle to Stabilize Signals
                  wait until rising_edge(ClkxS);
                  wait until rising_edge(ClkxS);
                  
                  -- Convert Color Vectors to 8-bit Integers (Assuming COLOR_BW = 4)
                  red_val   := (to_integer(unsigned(RedxS)) * 255) / (2**COLOR_BW - 1);
                  green_val := (to_integer(unsigned(GreenxS)) * 255) / (2**COLOR_BW - 1);
                  blue_val  := (to_integer(unsigned(BluexS)) * 255) / (2**COLOR_BW - 1);
                  
                  -- Write RGB Values to PPM File
                  write(line_buffer, red_val);
                  write(line_buffer, string'(" "));
                  write(line_buffer, green_val);
                  write(line_buffer, string'(" "));
                  write(line_buffer, blue_val);
                  writeline(output_file, line_buffer);
              end loop;

              for i in 0 to 100 loop
                  VSEdgexS <= '1';
                  wait until rising_edge(ClkxS);
                  VSEdgexS <= '0';
                  wait for 1 us;
              end loop;
          end loop;

          wait for 100us;
        end loop;

        -- === Capture Plate Region (256x64) ===
        for dy in 0 to 63 loop
            for dx in 0 to 255 loop
                -- Set X Coordinate across the Plate Width
                XCoordxD <= to_unsigned(100 - 128 + dx, COORD_BW); -- HALF_REGION = 128 for 256 width
                
                -- Set Y Coordinate at the Bottom of the Screen
                YCoordxD <= to_unsigned(VS_DISPLAY - 64 + dy, COORD_BW); 
                
                -- Wait for Two Clock Cycles to Stabilize Signals
                wait until rising_edge(ClkxS);
                wait until rising_edge(ClkxS);
                
                -- Convert Color Vectors to 8-bit Integers (Assuming COLOR_BW = 4)
                red_plate   := (to_integer(unsigned(RedxS)) * 255) / (2**COLOR_BW - 1);
                green_plate := (to_integer(unsigned(GreenxS)) * 255) / (2**COLOR_BW - 1);
                blue_plate  := (to_integer(unsigned(BluexS)) * 255) / (2**COLOR_BW - 1);
                
                -- Write RGB Values to Plate PPM File
                write(line_plate, red_plate);
                write(line_plate, string'(" "));
                write(line_plate, green_plate);
                write(line_plate, string'(" "));
                write(line_plate, blue_plate);
                writeline(output_plate, line_plate);
            end loop;
        end loop;

        -- End of Simulation
        stop;
    end process stimulus_process;

end architecture tb;
