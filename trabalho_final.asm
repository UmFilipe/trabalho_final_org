# Desenvolvido por:
# - Eduardo Pazzini Zancanaro (2221101031)
# - Filipe Medeiros de Almeida (2221101029)

.data
    node_size:	.word 8		       #(8 bytes)
    head:       .word 0                # Ponteiro para o início da lista
    current:    .space 4               # Espaço para armazenar o ponteiro atual
    menu:   .asciz "\n1. Inserir elemento na lista\n2. Remover elemento por indice\n3. Remover elemento por valor\n4. Mostrar todos os elementos\n5. Mostrar estatisticas\n6. Sair\nEscolha uma opcao: "
    insert_msg: .asciz "\nDigite um valor para ser inserido na lista: \n"
    insert_success: .asciz "\nValor inserido na lista.\n"
    insert_fail:    .asciz "\nErro ao inserir elemento na lista.\n"
    remove_by_index_msg: .asciz "\nDigite o índice da lista que deseja remover\n"
    remove_by_value_msg: .asciz "\nDigite o valor da lista que deseja remover\n"
    remove_success: .asciz "\nElemento removido da lista.\n"
    remove_fail:    .asciz "\nErro ao remover elemento da lista.\n"
    list_elements:  .asciz "\nElementos da lista: \n"
    empty_list: .asciz "Lista vazia.\n"
    stats_message:  .asciz "\nEstatísticas da lista: \n"
    exit_message:   .asciz "\nSaindo do programa...\n"

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
    beq a0, t1, call_insert_element # Vai para a função de inserir elemento caso o número em a0 (input) seja 1
    li t1, 2
    beq a0, t1, call_remove_by_index # Vai para a função de remover elemento pelo índice caso o número em a0 (input) seja 2
    li t1, 3
    beq a0, t1, call_remove_by_value # Vai para a função de remover elemento caso o número em a0 (input) seja 3
    li t1, 4
    beq a0, t1, call_print_list # Vai para a função que imprime a lista caso o número em a0 (input) seja 4
    li t1, 5
    beq a0, t1, call_print_stats # Vai para a função que imprime as estatísticas caso o número em a0 (input) seja 5
    li t1, 6
    beq a0, t1, call_exit # Vai para a função de saída do programa caso o número em a0 (input) seja 6

    j main

# Função de inserção (1)

call_insert_element:
    la a0, insert_msg
    li a7, 4
    ecall # Mostra mensagem de inserção

    li a7, 5
    ecall # Lê o valor inteiro do usuário

    mv a1, a0 # Passa o valor a ser inserido
    la a0, head # Passa o ponteiro para o início da lista
    call insert_element
    # Verifica o retorno da função
    li t1, 1
    beq a0, t1, insert_success_label # Vai para a etiqueta de sucesso se o retorno for 1
    j insert_fail_label

insert_success_label:
    j insert_success_message

insert_element:
    # Aloca espaço para um novo nó
    mv t2, a0                 # t2 agora aponta para o novo nó
    li a7, 9                  # Alocação de memória
    lw a0, node_size          # Tamanho do nó (8 bytes)
    ecall
    beqz t2, insert_fail_label      # Falha na alocação de memória

    # Armazena o valor no novo nó
    sw a1, 0(a0)              # Armazena valor no novo nó
    li t0, 0
    sw t0, 4(a0)              # Inicializa o campo 'próximo' do novo nó com 0 (fim da lista)

    # Verifica se a lista está vazia
    lw t0, 0(t2)
    beqz t0, insert_first     # Se a lista está vazia, insere no início
    
    lw t5, 0(t0) 	      #Pega valor primeiro nó
    blt a1, t5, insert_first  #Verifica se o primeiro valor é maior que o novo valor
    
    # Insere de forma ordenada
    mv t1, t0                 # t1 é o ponteiro para o nó atual
    lw t3, 0(t1)              # t3 é o valor do nó atual

insert_loop:
    lw t4, 4(t1)              # t4 é o ponteiro para o próximo nó
    beqz t4, insert_here      # Se não há próximo, insere aqui
    lw t5, 0(t4)              # t5 é o valor do próximo nó
    blt a1, t5, insert_here   # Se o valor a inserir é menor que o próximo, insere aqui
    mv t1, t4                 # Avança para o próximo nó
    j insert_loop

insert_here:
    sw a0, 4(t1)              # Atualiza o ponteiro 'próximo' do nó atual para o novo nó
    sw t4, 4(a0)              # Atualiza o ponteiro 'próximo' do novo nó para o próximo nó
    li a0, 1                  # Retorna sucesso
    j insert_done

insert_first:
    sw a0, 0(t2)              # Atualiza o ponteiro 'próximo' do nó atual para o novo nó
    sw t0, 4(a0)              # Atualiza o ponteiro 'próximo' do novo nó para o próximo nó
    li a0, 1                  # Retorna sucesso

insert_done:
    ret

insert_fail_label:
    li a0, -1                 # Retorna falha
    ret

insert_success_message:
    la a0, insert_success
    li a7, 4
    ecall
    j main

# Função de remoção por índice (2)

call_remove_by_index:
    call remove_by_index

remove_by_index:
    la a0, remove_by_index_msg 
    li a7, 4
    ecall # Imprime mensagem de remoção por índice

    li a7, 5
    ecall # Lê o valor inteiro do usuário
    # Verifica se o input é válido
    bltz a0, invalid_input
    bgez a0, valid_input

invalid_input:
    la a0, remove_fail
    li a7, 4
    ecall
    j main

valid_input:
    la a0, remove_success
    li a7, 4
    ecall
    j main

# Função de remoção por valor (3)

call_remove_by_value:
    call remove_by_value

remove_by_value:
    la a0, remove_by_value_msg
    li a7, 4
    ecall # Imprime mensagem de remoção por valor

    li a7, 5
    ecall # Lê o valor inteiro do usuário
    # Verifica se o input é válido
    bltz a0, invalid_input_value
    bgez a0, valid_input_value

invalid_input_value:
    la a0, remove_fail
    li a7, 4
    ecall
    j main

valid_input_value:
    la a0, remove_success
    li a7, 4
    ecall
    j main
    
# Função de imprime a lista (4)

call_print_list:
    call print_list

print_list:
    la a0, list_elements
    li a7, 4
    ecall

    # Verifica se a lista está vazia
    la t1, head
    lw t0, 0(t1)
    beq t0, zero, print_empty_list

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

print_empty_list:
    # Imprime nova linha
    la a0, empty_list
    li a7, 4        
    ecall

    j main

# Função que imprime as estatísticas (5)

call_print_stats:
    call print_stats

print_stats:
    la a0, stats_message
    li a7, 4
    ecall
    j main

# Função que sai do programa (6)

call_exit:
    call exit

exit:
    la a0, exit_message
    li a7, 4
    ecall
    li a7, 10
    ecall
