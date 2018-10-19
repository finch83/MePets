//============================================================================
// Name        : Fox_recurs.cpp
// Author      : 
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <iostream>

using namespace std;

int func(int y)
{
	cout << y << " | ";
	if(y == 4)
		return 1;
	( (y % 2) ? func(++y) : func(y + 1));
	cout << " @ " << y << " | ";

	return 0;
}

int main()
{
	func(1);
    return 0;
}
