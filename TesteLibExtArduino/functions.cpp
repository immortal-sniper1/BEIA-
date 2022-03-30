void*   ptr=NULL; // pointer fara tip
int var=9 ;
void* ptr2=&var; // ia afresa de memorie a lui var si o salveaza in ptr2
int* ptr3=&var; //pointer determinat , care stie ca este de 4 bytes
*ptr3=10 ; // inlocuieste in memorie ce era in pointer cu 10 efectiv el face var=10



char* CevaAici = new char[8];  // aici practic cer 8 bytes de memorie SI returneaza de unde incep 
menset(CevaAici , 0 ,8 );  // asta pune in memorie in 8 bytes valoarea 0 , deci practic suprascrie ce era acolo