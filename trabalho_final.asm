# Desenvolvido por:
# - Eduardo Pazzini Zancanaro (2221101031)
# - Filipe Medeiros de Almeida (2221101029)

    .data
        menu:   .asciz "\n1. Inserir elemento na lista\n2. Remover elemento por indice\n3. Remover elemento por valor\n4. Mostrar todos os elementos\n5. Mostrar estatisticas\n6. Sair\nEscolha uma opcao: "
        insert_success: .asciz "\nValor inserido na lista.\n"
        insert_fail:    .asciz "\nErro ao inserir elemento na lista.\n"
        remove_success: .asciz "\nElemento removido da lista.\n"
        remove_fail:    .asciz "\nErro ao remover elemento da lista.\n"
        list_elements:  .asciz "\nElementos da lista: \n"
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
    beq a0, t1, insert_element # Vai para a função de inserir elemento caso o número em a0 (input) seja 1
    li t1, 2
    beq a0, t1, remove_by_index # Vai para a função de remover elemento pelo índice caso o número em a0 (input) seja 2
    li t1, 3
    beq a0, t1, remove_by_value # Vai para a função de remover elemento caso o número em a0 (input) seja 3
    li t1, 4
    beq a0, t1, print_list # Vai para a função que imprime a lista caso o número em a0 (input) seja 4
    li t1, 5
    beq a0, t1, print_stats # Vai para a função que imprime as estatísricas caso o número em a0 (input) seja 5
    li t1, 6
    beq a0, t1, exit # Vai para a função de saída do programa caso o número em a0 (input) seja 6

    j main

insert_element:
    la a0, insert_success
    li a7, 4
    ecall
    j main

remove_by_index:
    la a0, remove_success
    li a7, 4
    ecall
    j main

remove_by_value:
    la a0, remove_success
    li a7, 4
    ecall
    j main
    
print_list:
    la a0, list_elements
    li a7, 4
    ecall
    j main

print_stats:
    la a0, stats_message
    li a7, 4
    ecall
    j main

exit:
    la a0, exit_message
    li a7, 4
    ecall
    li a7, 10
    ecall
