#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "structs.h"

list * create_list(){
    list * new_list = (list *)malloc(sizeof(list));
    new_list->head = NULL;
    new_list->last_created = NULL;
    return new_list;
}

node * new_node(list * curr_list, char*lexem){
    if(curr_list->last_created == NULL){
        curr_list->head = (node *)malloc(sizeof(node));
        curr_list->last_created = curr_list->head;
        node * refer = curr_list->last_created;
    
        strcpy(refer->lexeme, lexem);
        refer->next = NULL;
        return refer;
    }

    node * refer = search_node(curr_list, lexem);
    if(refer) return refer; 
    
    refer = curr_list->last_created;
    refer->next = (node *)malloc(sizeof(node));
    refer = refer->next;
    curr_list->last_created = refer;
    
    strcpy(refer->lexeme, lexem);
    refer->next = NULL;
    return refer;
}

node * search_node(list * curr_list, char*lexem){
    node * refer = curr_list->head;
    while(refer){
        if(strcmp(refer->lexeme, lexem) == 0){
            return refer;
        }
        else{
            refer = refer->next;
        }
    }
    return NULL;
}

Node * create_node(char * val) {
    Node * node = (Node *)malloc(sizeof(Node));
    strcpy(node->val, val);
    node->child = NULL;
    node->sibling = NULL;
    return node;
}

void add_child(Node *parent, Node *child){
    if (parent->child == NULL) {
        parent->child = child;
        return;
    }
    parent = parent->child;
    
    while (parent->sibling){
        parent = parent->sibling;
    }

    parent->sibling = child;
    
}

void print_tree(Node * root, int indent){
    if (root == NULL) return;
    
    for (int i = 0; i < indent; i++)
    {
        printf("   ");
    }
    
    printf("%s\n", root->val);

    indent = indent + 1;

    root = root->child;

    while(root){
        print_tree(root,indent);
        root=root->sibling;
    }

}