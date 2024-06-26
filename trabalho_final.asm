# Desenvolvido por:
# - Eduardo Pazzini Zancanaro (2221101031)
# - Filipe Medeiros de Almeida (2221101029)

.data

    node_size:	.word 8		           # Tamanho do nó (8 bytes)
    head:       .word 0                # Ponteiro para o início da lista
    insert_count:   .word 0            # Contador de inserções
    remove_count:   .word 0            # Contador de remoções

    menu:   .asciz "\n1. Inserir elemento na lista\n2. Remover elemento por indice\n3. Remover elemento por valor\n4. Mostrar todos os elementos\n5. Mostrar estatisticas\n6. Sair\nEscolha uma opcao: "
    insert_msg: .asciz "\nDigite um valor para ser inserido na lista: \n"
    insert_success: .asciz "\nValor inserido na lista.\n"
    insert_fail:    .asciz "\nErro ao inserir elemento na lista.\n"
    remove_by_index_msg: .asciz "\nDigite o índice da lista que deseja remover\n"
    remove_by_value_msg: .asciz "\nDigite o valor da lista que deseja remover\n"
    remove_success: .asciz "\nElemento removido da lista.\n"
    remove_fail:    .asciz "\nErro ao remover elemento da lista.\n"
    list_elements:  .asciz "\nElementos da lista: \n"
    empty_list: .asciz "\nLista vazia.\n"
    stats_message:  .asciz "\nEstatísticas da lista: \n"
    min_value_msg:  .asciz "\nMenor valor: "
    max_value_msg:  .asciz "\nMaior valor: "
    total_inserts_msg: .asciz "\nTotal de inserções: "
    total_removes_msg: .asciz "\nTotal de remoções: "
    total_elements_msg: .asciz "\nTotal de elementos: "
    exit_message:   .asciz "\nSaindo do programa...\n"
    new_line: .asciz "\n"

.text

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

# --------------------------------------------------#
#					Insere Valor Ordenado			                #
# --------------------------------------------------#
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
    mv t1, t4                 # Avança para o próximo nó (faz t1 apontar pro próximo nó)
    j insert_loop

insert_here:
    sw a0, 4(t1)              # t1 = nó anterior // agora aponta pro novo valor
    sw t4, 4(a0)              # t4 = próximo nó // novo valor (a0) agora aponta pra ele
    li a0, 1                  # Retorna sucesso
    j insert_done

insert_first:
    sw a0, 0(t2)              # t2 = cabeça da lista // agora aponta pro novo valor
    sw t0, 4(a0)              # t0 = antigo primeiro valor // agora é o segundo pois a0 aponta pra ele
    li a0, 1                  # Retorna sucesso

insert_done:
    # Incrementa o contador de inserções
    la t0, insert_count
    lw t1, 0(t0)
    addi t1, t1, 1
    sw t1, 0(t0)
    ret

insert_fail_label:
    li a0, -1                 # Retorna falha
    j main

insert_success_message:
    la a0, insert_success
    li a7, 4
    ecall
    j main

# --------------------------------------------------#
#					Remove Por Indíce 				                #
# --------------------------------------------------#
call_remove_by_index:
    call remove_by_index
    j main

remove_by_index:
    la a0, remove_by_index_msg
    li a7, 4
    ecall # Imprime mensagem de remoção por índice

    li a7, 5
    ecall # L� o valor inteiro do usuário
     # Chama a função de remoção por index com o valor lido em a0
    mv a1, a0
    la a0, head
    mv t6, ra
    call remove_element_by_index

    li t1, 1
    beq a0, t1, remove_success_label # Vai para a etiqueta de sucesso se o retorno for 1
    j remove_fail_label


    la a0, remove_by_index_msg
    li a7, 4
    ecall # Imprime mensagem de remoçãoo por valor

    li a7, 5
    ecall # L� o valor inteiro do usuário
    # Chama a função de remoção por valor com o valor lido em a0
    mv a1, a0
    la a0, head
    call remove_element_by_index

    # Verifica o retorno da função
    li t1, 1
    beq a0, t1, remove_success_label # Vai para a etiqueta de sucesso se o retorno for 1
    j remove_fail_label

remove_element_by_index:
    la t0, head
    lw t1, 0(t0)

    # Verifica se a lista está vazia
    bnez t1, remove_index_not_empty # Se a lista estiver vazia, falha
    li a0, -1
	ret
	
remove_index_not_empty:
    # Inicializa variáveis
    mv t4, t0               # t4 = ponteiro para o nó anterior
    mv t2, a1               # t2 = index a ser removido
    li a6, 1	    	    # t6 = primeiro index
    

remove_by_index_loop:
    beq a6, t2, remove_element
    addi a6, a6, 1

    # Atualiza os ponteiros e variáveis para o próximo nó
    mv t4, t1               # Atualiza ponteiro para o nó anterior
    lw t1, 4(t1)            # Carrega o ponteiro para o próximo nó
    bnez t1, remove_by_index_loop    # Se houver próximo nó, continua o loop

    # Se não encontrou o index, retorna falha
    j remove_fail_label

# --------------------------------------------------#
#					Remove Por Valor 				                  #
# --------------------------------------------------#

call_remove_by_value:
    call remove_by_value
    j main

remove_by_value:
    la a0, remove_by_value_msg
    li a7, 4
    ecall # Imprime mensagem de remoção por valor

    li a7, 5
    ecall # Lê o valor inteiro do usuário
    
    # Chama a função de remoção por valor com o valor lido em a0
    mv a1, a0
    la a0, head
    mv t6, ra
    call remove_element_by_value

    # Verifica o retorno da função
    li t1, 1
    beq a0, t1, remove_success_label # Vai para a etiqueta de sucesso se o retorno for 1
    j remove_fail_label

remove_element_by_value:
    la t0, head            # Carrega o endereço da cabeça da lista
    lw t1, 0(t0)           # Carrega o ponteiro para o primeiro nó

    # Verifica se a lista está vazia
    beqz t1, remove_fail_label # Se a lista estiver vazia, falha

    # Inicializa variáveis
    mv t4, t0               # t4 = ponteiro para o nó anterior
    mv t2, a1               # t2 = valor a ser removido

remove_by_value_loop:
    lw t5, 0(t1)            # Carrega o valor do nó atual
	mv a1, t5				# Define a1 com valor do elemento
	
    # Verifica se o valor do nó é igual ao valor a ser removido
    beq t5, t2, remove_element

    # Atualiza os ponteiros e variáveis para o próximo nó
    mv t4, t1               # Atualiza ponteiro para o nó anterior
    lw t1, 4(t1)            # Carrega o ponteiro para o próximo nó
    bnez t1, remove_by_value_loop    # Se houver próximo nó, continua o loop

    # Se não encontrou o valor, retorna falha
    j remove_fail_label

# --------------------------------------------------#
#					Remove Valor					                    #
# --------------------------------------------------#
remove_element:
    # Remove o nó encontrado
    lw t5, 4(t1)            # Carrega o ponteiro para o próximo nó
    
    # Atualiza a cabeça da lista se o nó removido for o primeiro nó
    beq t4, t0, update_head_remove_value
    
    sw t5, 4(t4)            # t1 = nó a ser removido // 
                            # t4 = nó anterior // t5 próximo nó // 
                            # t4 agora aponta pra t5, ignorando o intermediario que foi removido
    sw zero, 0(t1)          # Apaga o valor do nó atual definindo-o como 0

    j remove_success_label

update_head_remove_value:
    lw t5, 4(t1)    # t5 = próximo nó depois do que irá ser removido       
    sw t5, 0(t4)    # t4 = aponta pro primeiro elemento pois elemento a ser removido é o primeiro
                    # Coloca a cabeça da lista para apontar para o t5 (novo primeiro) 

    # Verifica se a lista ficou vazia
    beqz t5, empty_list_after_remove_value

    j remove_success_label

empty_list_after_remove_value:
    sw zero, 0(t0)          # Define a cabeça da lista como 0 (vazia)

remove_success_label:
	# Incrementa o contador de remoções
    la t0, remove_count
    lw t1, 0(t0)
    addi t1, t1, 1
    sw t1, 0(t0)

    la a0, remove_success
    li a7, 4
    ecall    
    li a0, 1         # Retorna Sucesso
	
	mv ra, t6
    ret

remove_fail_label:
    la a0, remove_fail
    li a7, 4
    ecall
    
    li a0, -1
    li a1, -1
    
    mv ra, t6
    ret


# --------------------------------------------------#
#					Função Imprime Lista			                #
# --------------------------------------------------#
call_print_list:
    call print_list
    j main

print_list:
    la a0, list_elements
    li a7, 4
    ecall

    # Verifica se a lista está vazia
    la t1, head
    lw t0, 0(t1)
    beq t0, zero, print_empty_list

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

    la a0, new_line
    li a7, 4
    ecall

    ret

print_empty_list:
    # Imprime mensagem de lista vazia
    la a0, empty_list
    li a7, 4
    ecall

    ret

# --------------------------------------------------#
#					Mostra Estatistica 				                #
# --------------------------------------------------#
call_print_stats:
    call print_stats
    j main

print_stats:
    la a0, stats_message
    li a7, 4
    ecall

    # Exibe o total de inserções
    la a0, total_inserts_msg
    li a7, 4
    ecall

    la t0, insert_count
    lw a0, 0(t0)           # Total de inserções
    li a7, 1
    ecall

    la a0, total_removes_msg
    li a7, 4
    ecall

    la t0, remove_count
    lw a0, 0(t0)           # Total de inserções
    li a7, 1
    ecall

    # Verifica se a lista está vazia
    la t1, head
    lw t0, 0(t1)
    beq t0, zero, print_empty_list_stats

    # Inicializa as variáveis de estatísticas
    lw t2, 0(t0)           # t2 = menor valor (inicializa com o valor do primeiro nó)
    lw t3, 0(t0)           # t3 = maior valor (inicializa com o valor do primeiro nó)
    li t4, 0               # t4 = contador de elementos

stats_loop:
    lw t5, 0(t0)           # t5 = valor do nó atual
    blt t5, t2, update_min # Atualiza menor valor se necessário
    bgt t5, t3, update_max # Atualiza maior valor se necessário

    addi t4, t4, 1         # Incrementa o contador de elementos
    lw t0, 4(t0)           # Carrega o endereço do próximo nó
    bne t0, zero, stats_loop # Se 'próximo' não for zero, continuar
	
	la a0, total_elements_msg
    li a7, 4
    ecall

    mv a0, t4           # Total de elementos
    li a7, 1
    ecall
	
	
    # Exibe o menor valor
    la a0, min_value_msg
    li a7, 4
    ecall

    mv a0, t2              # Menor valor
    li a7, 1
    ecall

    # Exibe o maior valor
    la a0, max_value_msg
    li a7, 4
    ecall

    mv a0, t3              # Maior valor
    li a7, 1
    ecall

    la a0, new_line
    li a7, 4
    ecall

    ret

update_min:
    mv t2, t5              # Atualiza menor valor
    j stats_loop

update_max:
    mv t3, t5              # Atualiza maior valor
    j stats_loop

print_empty_list_stats:
    # Imprime mensagem de lista vazia
    la a0, empty_list
    li a7, 4
    ecall
    ret


# --------------------------------------------------#
#					Fecha Programa  				                  #
# --------------------------------------------------#

call_exit:
    call exit

exit:
    la a0, exit_message
    li a7, 4
    ecall
    li a7, 10
    ecall