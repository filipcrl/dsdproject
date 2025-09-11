--=============================================================================
-- @file mandelbrot.vhdl
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
-- mandelbrot
--
-- @brief This file specifies a basic circuit for mandelbrot
--
--=============================================================================

--=============================================================================
-- ENTITY DECLARATION FOR MANDELBROT
--=============================================================================
entity mandelbrott is
  port (
    CLKxCI : in std_logic;
    RSTxRI : in std_logic;

    WExSO   : out std_logic; -- write enable 
    XxDO    : out unsigned(COORD_BW - 1 downto 0);
    YxDO    : out unsigned(COORD_BW - 1 downto 0);
    ITERxDO : out unsigned(MEM_DATA_BW - 1 downto 0)
  );
end entity mandelbrott;

--=============================================================================
-- ARCHITECTURE DECLARATION
--=============================================================================
architecture rtl of mandelbrott is

--  constant z0 : signed((N_BITS+5)-1 downto 0) :=  resize(shift_right(C_RE_0 * C_RE_0 + C_IM_0 * C_IM_0, N_FRAC), N_BITS+5);
  -- TODO: Implement your own code here
  signal CNT_PIXxDN, CNT_PIXxDP : unsigned(COORD_BW-1 downto 0);
  signal CNT_LGNxDN, CNT_LGNxDP : unsigned(COORD_BW-1 downto 0);
  signal CNT_PIX_COMPxDN, CNT_PIX_COMPxDP : signed(N_BITS+1 -1 downto 0);
  signal CNT_LGN_COMPxDN, CNT_LGN_COMPxDP : signed(N_BITS+1 -1 downto 0);
  signal CNT_ITExDN, CNT_ITExDP : unsigned(MEM_DATA_BW - 1 downto 0);
  
  signal Enable : std_logic;
  signal Condition : std_logic;
  
  signal z_r2, z_im2 : signed((N_BITS+5)-1 downto 0);  
  signal z_rxDP, z_rxDN, z_imxDP, Z_imxDN : signed(N_BITS+1-1 downto 0);
  

--=============================================================================
-- ARCHITECTURE BEGIN
--=============================================================================
begin

  Cnt : PROCESS(CLKxCI, RSTxRI) is    -- FlipFlop
    BEGIN -- Process Name : reg1
        IF RSTxRI = '1' THEN
            CNT_PIXxDP <= (OTHERS => '0');
            CNT_LGNxDP <= (OTHERS => '0');
            CNT_PIX_COMPxDP <= resize(C_RE_0, N_BITS+1);
            CNT_LGN_COMPxDP <= resize(C_IM_0, N_BITS+1);
            CNT_ITExDP <= (OTHERS => '0');
        ELSIF CLKxCI'EVENT AND CLKxCI = '1' THEN
            CNT_PIXxDP <= CNT_PIXxDN;
            CNT_LGNxDP <= CNT_LGNxDN;
            CNT_PIX_COMPxDP <= CNT_PIX_COMPxDN;
            CNT_LGN_COMPxDP <= CNT_LGN_COMPxDN;
            CNT_ITExDP <= CNT_ITExDN;
        END IF;
    END PROCESS Cnt;        
   
    CNT_PIXxDN <= CNT_PIXxDP + 1 when (CNT_PIXxDP < (HS_DISPLAY - 1) and Enable = '1') else
                 (OTHERS => '0') when Enable = '1' else
                 CNT_PIXxDP;
    
    CNT_LGNxDN <= CNT_LGNxDP + 1 when (CNT_PIXxDP >= HS_DISPLAY - 1) and (Enable = '1') else
                  (OTHERS => '0') when (CNT_LGNxDP >= VS_DISPLAY - 1) and (Enable = '1') else
                  CNT_LGNxDP;
                  
    CNT_PIX_COMPxDN <= CNT_PIX_COMPxDP + C_RE_INC when Enable = '1' else
                       resize(C_RE_0, N_BITS+1) when Enable = '1' and (CNT_PIXxDP >= HS_DISPLAY - 1) else                       
                       CNT_PIX_COMPxDP;
                       
   CNT_LGN_COMPxDN <= CNT_LGN_COMPxDP + C_IM_INC when Enable = '1' and CNT_PIXxDP >= HS_DISPLAY-1 else
                      resize(C_IM_0, N_BITS+1) when Enable = '1' and (CNT_LGNxDP >= VS_DISPLAY - 1) else
                      CNT_LGN_COMPxDP;
                      
   CNT_ITExDN <= CNT_ITExDP + 1 when Enable = '0' else
                 (OTHERS => '0');
                 
   Enable <= '1' when ((z_r2 + z_im2) >= 4*(2**N_FRAC) or (CNT_ITExDP >= MAX_ITER)) else 
              '0';
              
   z_r2 <= resize(z_rxDP * z_rxDP, N_BITS+5);
   z_im2 <= resize(z_imxDP * z_imxDP, N_BITS+5);
   
   AlgoVar : Process(all) is 
    Begin
        IF Enable = '1' Then
            z_rxDP <= CNT_PIX_COMPxDP;
            z_imxDP <= CNT_LGN_COMPxDP;
        ELSIF CLKxCI'EVENT AND CLKxCI = '1' THEN
            z_rxDP <= z_rxDN;
            z_imxDP <= z_imxDN;
        END IF;
    END PROCESS AlgoVar;
    
   Algo : Process(all) is
    Begin
        If Enable = '0' then
            z_rxDN <= resize(shift_right(z_r2 - z_im2 + CNT_PIX_COMPxDP*(2**N_FRAC),N_FRAC),N_BITS+1);
            z_imxDN <= resize(shift_right(2*z_rxDP*z_imxDP + CNT_LGN_COMPxDP*(2**N_FRAC),N_FRAC),N_BITS+1);
        else
            z_rxDN <= z_rxDP;
            z_imxDN <= z_imxDP;
        end if;
    END PROCESS Algo;
   
-- connecte signux ‡ output
WExSO <= Enable;

XxDO <= CNT_PIXxDP;

YxDO <= CNT_LGNxDP;        

ITERxDO <= CNT_ITExDP;      

end architecture rtl;
--=============================================================================
-- ARCHITECTURE END
--=============================================================================
