#include <iostream>
#include<windows.h>
#include <math.h>

using namespace std;

int main()
{

/*
int progress = 0;
while (progress < 1000) {
    int barWidth = 100;

    std::cout << "[";
    int pos =progress/ barWidth  ;

    for (int i = 0; i < barWidth; ++i)
        {
        if (i < pos)
        std::cout << "=";
        else if (i == pos)
        std::cout << ">";
        else
        std::cout << " ";
        }
    std::cout << "] " << int(progress /10 ) << " %\r";
    std::cout.flush();
    Sleep(200);
    progress += 10; // for demonstration only
}
std::cout << std::endl;
*/



int progress=0; // de la 0 la 100
int barWidth=100;
int pos;

while ( progress <= 100)
{
    cout<<"[[";
    pos=round( barWidth / progress );
        for (int i = 0; i < barWidth; ++i)
        {
                    if (i <= pos)
                    {
                        cout << "&";
                    }
                    else
                    {
                        cout << " ";
                    }
        }
            cout << "]] " << progress /100 << " %\r";
            cout.flush();
            Sleep(500);
            progress += 5;


}
cout << endl;



}
