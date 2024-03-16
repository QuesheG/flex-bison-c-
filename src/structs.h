typedef struct node{
    char lexeme[32];
    struct node * next;
}node;

typedef struct list{
    node * head;
    node * last_created;
}list;

list * lis;

typedef struct Node{
    char val[32];
    struct Node * child;
    struct Node * sibling;
} Node;

list * create_list();
node * new_node(list * curr_list, char*lexem);
node * search_node(list * curr_list, char*lexem);
node * update_node(list * curr_list, char*lexem, int func, int point, int space);

Node*create_node(char * val);
void add_child(Node * parent, Node * child);
void print_tree(Node * root, int indent);