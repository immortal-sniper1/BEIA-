void*   ptr = NULL; // pointer fara tip
int var = 9 ;
void* ptr2 = &var; // ia afresa de memorie a lui var si o salveaza in ptr2
int* ptr3 = &var; //pointer determinat , care stie ca este de 4 bytes
*ptr3 = 10 ; // inlocuieste in memorie ce era in pointer cu 10 efectiv el face var=10



char* CevaAici = new char[8];  // aici practic cer 8 bytes de memorie SI returneaza de unde incep
menset(CevaAici , 0 , 8 ); // asta pune in memorie in 8 bytes valoarea 0 , deci practic suprascrie ce era acolo

//////////////////////////////////////////////////////////////////

void PrintValCeva(int x)
{

	std::cout << "Valoare: " << x << std::endl;
}


void FunctieDeFunctii( int x,  void(*functiax)(int)    )
{
	x = x + 2;
	// ceva cod aici
	functiax(x);
	// ceva cod aici
	x = x * 2;
}

int main()
{
	r = 14;
	FunctieDeFunctii( r, PrintValCeva);
}

/////////// side note:
void(*PointerSpreFunctie)(int) = PrintValCeva;
// void este tipul de variabila returnata de PrintValCeva
// int este tipul de variabila de input pt functia PrintValCeva


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// invocare de functie folosind pointer de functie (asta e exemplul 2)

int adder(int a, int b)
{
	return a + b
}

int main()
{
	int(*PointerSpreFunctie2)( int , int )
	// int este tipul de output pt functia adder
	// (int, int) sunt tipurile de input pt functia adder

	x = adder(3, 8);
	x = PointerSpreFunctie2(3, 8);
	//astea 2 lini de cod fac exact acelasi lucru , deci sunt echivalente

	// dece se folosesc acesti pointeri de functii?
	// pt a putea refolosi cod pe viitor pt ca se poate schimba usor functia adder
}

/////////////////////////////////////
// functie cu pointer ca parametru

void validator( int x, int y,  int(*FunctiaDeReferinta)(int, int)  )  // aici putem da adder ca functie de referinta
{
	//ceva ceva aici 
}


//se apeleaza asa

validator( 5 , 4 , PointerSpreFunctie2 );