    .data
menu:   .asciz "\n1. Inserir elemento na lista\n2. Remover elemento por indice\n3. Remover elemento por valor\n4. Mostrar todos os elementos\n5. Mostrar estatisticas\n6. Sair\nEscolha uma opcao: "
insert_success: .asciz "\nValor inserido na lista.\n"
insert_fail:    .asciz "\nErro ao inserir elemento na lista.\n"
remove_success: .asciz "\nElemento removido da lista.\n"
remove_fail:    .asciz "\nErro ao remover elemento da lista.\n"
list_elements:  .asciz "\nElementos da lista: \n"
stats_message:  .asciz "\nEstatisticas da lista: \n"
exit_message:   .asciz "\nSaindo do programa...\n"

    .text
    .globl inicio

inicio:
main:
    la a0, menu
    li a7, 4
    ecall

    li a7, 5
    ecall
    li t0, 0
    li t1, 1
    beq a0, t1, insert_element
    li t1, 2
    beq a0, t1, remove_by_index
    li t1, 3
    beq a0, t1, remove_by_value
    li t1, 4
    beq a0, t1, print_list
    li t1, 5
    beq a0, t1, print_stats
    li t1, 6
    beq a0, t1, exit

    j main_loop

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
