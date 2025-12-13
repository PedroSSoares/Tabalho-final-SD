library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.matrix_types.all;

package matrix_types is
    -- Matriz 3x3 de 8 bits (Entradas)
    type mat3x3_8bit is array (0 to 2, 0 to 2) of unsigned(7 downto 0);
    -- Matriz 3x3 de 16 bits (Saída)
    type mat3x3_16bit is array (0 to 2, 0 to 2) of unsigned(15 downto 0);
end package;

entity PCPO is
    Port ( 
           clk      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           start    : in STD_LOGIC;
           done     : out STD_LOGIC;
           A        : in mat3x3_8bit;
           B        : in mat3x3_8bit;
           R        : out mat3x3_16bit           
         );
end PCPO;

architecture Behavioral of PCPO is

    type estado_t is (s0, s1, s2, s3);
    signal estado_atual : estado_t;
    
    --sinais PO 
    signal i, j, k : integer range 0 to 3;
    signal acc : unsigned(15 downto 0) := (others => '0');
    signal temp_R : mat3x3_16bit; -- Memória interna para guardar o resultado

    --PC -> PO
    signal clr_all : std_logic; -- Resetar tudo
    signal en_calc : std_logic; -- Habilitar cálculo
    signal inc_k   : std_logic; -- Incrementar k
    signal clr_k   : std_logic; -- Zerar k
    signal inc_j   : std_logic; -- Incrementar j
    signal clr_j   : std_logic; -- Zerar j
    signal inc_i   : std_logic; -- Incrementar i
    signal wr_en   : std_logic; -- Escrever na memória
    signal clr_acc : std_logic; -- Limpar acumulador

    --PO -> PC
    signal k_eq_2  : std_logic;
    signal j_eq_2  : std_logic;
    signal i_eq_2  : std_logic;

begin

    --PARTE DE CONTROLE (PC)
    process(clk, rst)
    begin
        
        if rst = '1' then
            estado_atual <= s0;
        elsif rising_edge(clk) then
            case estado_atual is
                when s0 =>
                    if start = '1' then
                        estado_atual <= s1;
                    end if;

                when s1 =>
                    if k_eq_2 = '1' then
                        estado_atual <= s2;
                    else
                        estado_atual <= s1;
                    end if;

                when s2 =>
                    -- Lógica para varrer colunas (j) e linhas (i)
                    if j_eq_2 = '0' then
                        estado_atual <= s1; -- Próxima coluna
                    else
                        if i_eq_2 = '0' then
                            estado_atual <= s1; -- Próxima linha
                        else
                            estado_atual <= s3; -- Terminou tudo
                        end if;
                    end if;

                when s3 =>
                    if start = '0' then
                        estado_atual <= s0;
                    end if;
            end case;
        end if;
    end process;

    -- PARTE COMBINACIONAL
    process(estado_atual, k_eq_2, j_eq_2, i_eq_2, start)
    begin
        
        clr_all <= '0'; en_calc <= '0'; inc_k <= '0'; clr_k <= '0';
        inc_j <= '0'; clr_j <= '0'; inc_i <= '0'; 
        wr_en <= '0'; clr_acc <= '0'; done <= '0';

        case estado_atual is
            when s0 =>
                if start = '1' then 
                    clr_all <= '1'; 
                end if;

            when s1 =>
                en_calc <= '1'; 
                if k_eq_2 = '0' then 
                    inc_k <= '1'; 
                end if; 

            when s2 =>
                wr_en   <= '1'; 
                clr_acc <= '1'; 
                clr_k   <= '1';
                
                if j_eq_2 = '0' then
                    inc_j <= '1'; 
                else
                    clr_j <= '1'; 
                    if i_eq_2 = '0' then
                        inc_i <= '1';
                    end if;
                end if;

            when s3 =>
                done <= '1';
        
        end case;
    end process;

    -- PARTE OPERATIVA (PO)
    process(clk)
    begin
        if rising_edge(clk) then
            if clr_all = '1' then
                i <= 0; 
                j <= 0; 
                k <= 0; 
                acc <= (others => '0');
            else
                if inc_k = '1' then 
                    k <= k + 1; 
                end if;
                
                if clr_k = '1' then 
                    k <= 0;     
                end if;
                
                if inc_j = '1' then 
                    j <= j + 1; 
                end if;
                
                if clr_j = '1' then 
                    j <= 0;     
                end if;
                
                if inc_i = '1' then 
                    i <= i + 1; 
                end if;
            
            end if;

            if clr_acc = '1' then
                acc <= (others => '0');
            elsif en_calc = '1' then
                acc <= acc + (A(i, k) * B(k, j));
            end if;

            if wr_en = '1' then
                temp_R(i, j) <= acc;
            end if;
        
        end if;
    end process;

    k_eq_2 <= '1' when k = 2 else '0';
    j_eq_2 <= '1' when j = 2 else '0';
    i_eq_2 <= '1' when i = 2 else '0';

    R <= temp_R;

end Behavioral;