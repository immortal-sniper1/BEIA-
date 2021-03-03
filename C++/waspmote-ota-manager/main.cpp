#include <iostream>
#include <fstream>





using namespace std;

string  decitit;
int sizex, verss;




int main()
{
  ofstream myfile;
  myfile.open ("UPGRADE.TXT");
  cout << "introduceti numele fisierului binar " << endl;
  cin >> decitit;
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





cin>>verss;
  return 0;
}
