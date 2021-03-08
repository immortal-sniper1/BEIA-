#include <iostream>
#include <fstream>
#include <string>




using namespace std;

string  decitit, qaz = "UPGRADE.TXT";
int sizex, verss;
bool x = true;



int main()
{
    /*
  //cout << "introduceti numele fisierului binar " << endl;
  cout << "introduceti numele de upgrade [NU UITA SA SCRII SI EXTENSIA SI AI GRIJA LA MARIME LITERE] " << endl;
  cin >> qaz;
  if (qaz[8] != '.')
  {
    x = false;
  }
  if (qaz[9] != 'T')
  {
    x = false;
  }
  if (qaz[10] != 'X')
  {
    x = false;
  }
  if (qaz[11] != 'T')
  {
    x = false;
  }



  while ( (qaz.length() != 11) || x   )
  {
    cout << "lungime " << qaz.length() << endl;
    cout << "extensia este " << x << endl;
    cout << "filename trebuie  sa fie 7 bytes + .TXT la sfarsit" << endl;
    cout << "introduceti numele de upgrade [NU UITA SA SCRII SI EXTENSIA SI AI GRIZA LA MARIME LITERE] " << endl;
    cin >> qaz;
  }
*/





  std::ofstream myfile (qaz);
  //ofstream myfile;
  //myfile.open ("UPGRADE.TXT");
  cout << "introduceti numele fisierului binar " << endl;
  cin >> decitit;


    while ( decitit.length() != 7    )
  {
    cout << "lungime " << decitit.length() << endl;
    cout << "filename trebuie  sa fie 7 bytes + RARA EXTENSIE la sfarsit" << endl;
    cout << "introduceti numele de upgrade [NU UITA SA SCRII SI EXTENSIA SI AI GRIZA LA MARIME LITERE] " << endl;
    cin >> decitit;
  }







  myfile << "FILE:";
  myfile << decitit;
  myfile << "\n";
  myfile << "PATH:/\n";
  cout << "introduceti marimea fisierului binar in bytes" << endl;
  cin >> sizex;
  myfile << "SIZE:";
  myfile << sizex;
  myfile << "\n";

  cout << "introduceti versiunea fisierului binar " << endl;
  cin >> verss;
  myfile << "VERSION:";
  myfile << verss;
  myfile << "\n";


  myfile.close();

  cin >> verss;
  return 1;
}
