# Desenvolvido por:
# - Eduardo Pazzini Zancanaro (2221101031)
# - Filipe Medeiros de Almeida (2221101029)

.data
    menu:   .asciz "\n1. Inserir elemento na lista\n2. Remover elemento por indice\n3. Remover elemento por valor\n4. Mostrar todos os elementos\n5. Mostrar estatisticas\n6. Sair\nEscolha uma opcao: "
    insert_msg: .asciz "\nDigite um valor para ser inserido na lista: \n"
    insert_success: .asciz "\nValor inserido na lista.\n"
    insert_fail:    .asciz "\nErro ao inserir elemento na lista.\n"
    remove_success: .asciz "\nElemento removido da lista.\n"
    remove_fail:    .asciz "\nErro ao remover elemento da lista.\n"
    list_elements:  .asciz "\nElementos da lista: \n"
    stats_message:  .asciz "\nEstatísticas da lista: \n"
    exit_message:   .asciz "\nSaindo do programa...\n"

    head:       .word 0                # Ponteiro para o início da lista
    node_size:  .word 8                # Tamanho de cada nó (4 bytes para valor + 4 bytes para próximo)
    current:    .space 4               # Espaço para armazenar o ponteiro atual

.text
.globl inicio

inicio:
main:
    la a0, menu 
    li a7, 4
    ecall # Mostra o menu

    li a7, 5 
    ecall # Pega o input do usuário
    li t0, 0
    li t1, 1
    beq a0, t1, insert_element # Vai para a função de inserir elemento caso o número em a0 (input) seja 1
    li t1, 2
    beq a0, t1, remove_by_index # Vai para a função de remover elemento pelo índice caso o número em a0 (input) seja 2
    li t1, 3
    beq a0, t1, remove_by_value # Vai para a função de remover elemento caso o número em a0 (input) seja 3
    li t1, 4
    beq a0, t1, print_list # Vai para a função que imprime a lista caso o número em a0 (input) seja 4
    li t1, 5
    beq a0, t1, print_stats # Vai para a função que imprime as estatísticas caso o número em a0 (input) seja 5
    li t1, 6
    beq a0, t1, exit # Vai para a função de saída do programa caso o número em a0 (input) seja 6

    j main

# Função de inserção (1)

insert_element:
    la a0, insert_msg
    li a7, 4
    ecall

    
    li a7, 5
    ecall # Lê o valor inteiro do usuário
    la t1, current
    sw a0, 0(t1)            # Armazena valor temporariamente em current

    # Aloca espaço para um novo nó
    li a7, 9                  # Alocação de memória
    lw a0, node_size          # Tamanho do nó (8 bytes)
    ecall
    mv t2, a0                 # t2 agora aponta para o novo nó

    # Armazena o valor no novo nó
    lw t0, 0(t1)
    sw t0, 0(t2)              # Armazena valor no novo nó

    # Inicializa o campo 'próximo' do novo nó com 0 (fim da lista)
    li t0, 0
    sw t0, 4(t2)

    # Verifica se a lista está vazia
    la t1, head
    lw t0, 0(t1)
    beq t0, zero, insert_first

    # Percorre até o final da lista
    mv t3, t0

find_end:
    lw t4, 4(t3)              # Carrega o campo 'próximo'
    beq t4, zero, end_found   # Se 'próximo' for 0, estamos no último nó
    mv t3, t4                 # Avança para o próximo nó
    j find_end

end_found:
    sw t2, 4(t3)              # Define o novo nó como o próximo do último nó
    j insert_done

insert_first:
    sw t2, 0(t1)              # Definir o novo nó como o cabeça da lista

insert_done:
    la a0, insert_success
    li a7, 4
    ecall
    j main

# Função de remoção por índice (2)

remove_by_index:
    la a0, remove_success
    li a7, 4
    ecall
    j main

# Função de remoção por valor (3)

remove_by_value:
    la a0, remove_success
    li a7, 4
    ecall
    j main
    
# Função de imprime a lista (4)

print_list:
    la a0, list_elements
    li a7, 4
    ecall

    # Verifica se a lista está vazia
    la t1, head
    lw t0, 0(t1)
    beq t0, zero, print_list_done

    # Percorre a lista e imprime cada elemento
print_list_loop:
    # Imprime valor do nó atual
    lw a0, 0(t0)           # Carrega o valor do nó atual
    li a7, 1               # Imprime inteiro
    ecall

    # Imprime espaço
    li a0, ' '
    li a7, 11     
    ecall

    # Carrega o endereço do próximo nó
    lw t0, 4(t0)           # Carrega o campo 'próximo'
    bne t0, zero, print_list_loop # Se 'próximo' não for zero, continuar

print_list_done:
    # Imprime nova linha
    li a0, '\n'
    li a7, 11         
    ecall

    j main

# Função que imprime as estatísticas (5)

print_stats:
    la a0, stats_message
    li a7, 4
    ecall
    j main

# Função que sai do programa (6)

exit:
    la a0, exit_message
    li a7, 4
    ecall
    li a7, 10
    ecall
