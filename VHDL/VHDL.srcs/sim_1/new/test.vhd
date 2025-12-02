library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.matrix_types.all; 

entity tb_PCPO is
end tb_PCPO;

architecture tb of tb_PCPO is

    component PCPO
        port (clk     : in std_logic;
              rst     : in std_logic;
              start   : in std_logic;
              matrizA : in mat3x3_8bit;
              matrizB : in mat3x3_8bit;
              resul   : out mat3x3_16bit;
              done    : out std_logic);
    end component;

    signal clk     : std_logic := '0';
    signal rst     : std_logic := '0';
    signal start   : std_logic := '0';
    
    signal matrizA : mat3x3_8bit := (others => (others => (others => '0')));
    signal matrizB : mat3x3_8bit := (others => (others => (others => '0')));
    signal resul   : mat3x3_16bit;
    signal done    : std_logic;

    constant TbPeriod : time := 10 ns; 

begin

    dut : PCPO
    port map (clk     => clk,
              rst     => rst,
              start   => start,
              matrizA => matrizA,
              matrizB => matrizB,
              resul   => resul,
              done    => done);

    process
    begin
        clk <= '0';
        wait for TbPeriod / 2;
        clk <= '1';
        wait for TbPeriod / 2;
    end process;

    stimuli : process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 20 ns;

        -- A = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
        matrizA(0,0) <= to_unsigned(1, 8); matrizA(0,1) <= to_unsigned(2, 8); matrizA(0,2) <= to_unsigned(3, 8);
        matrizA(1,0) <= to_unsigned(4, 8); matrizA(1,1) <= to_unsigned(5, 8); matrizA(1,2) <= to_unsigned(6, 8);
        matrizA(2,0) <= to_unsigned(7, 8); matrizA(2,1) <= to_unsigned(8, 8); matrizA(2,2) <= to_unsigned(9, 8);

        -- B = Identidade
        matrizB(0,0) <= to_unsigned(1, 8); matrizB(0,1) <= to_unsigned(0, 8); matrizB(0,2) <= to_unsigned(0, 8);
        matrizB(1,0) <= to_unsigned(0, 8); matrizB(1,1) <= to_unsigned(1, 8); matrizB(1,2) <= to_unsigned(0, 8);
        matrizB(2,0) <= to_unsigned(0, 8); matrizB(2,1) <= to_unsigned(0, 8); matrizB(2,2) <= to_unsigned(1, 8);

        wait for 20 ns;

        start <= '1';
        wait for TbPeriod; 
        start <= '0';

        wait until done = '1';
        wait for 50 ns;

        assert false report "Fim da Simulacao com Sucesso" severity failure;
        wait;
    end process;

end tb;