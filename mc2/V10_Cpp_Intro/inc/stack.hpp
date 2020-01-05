/*******************************************************************************
 * @file        stack.hpp
 * @brief
 * @details
 * @version     1.0
 * @author      Simon Burkhardt
 * @date        2020.01.05
*******************************************************************************/

#include <cassert> // see: http://www.cplusplus.com/reference/clibrary/cassert/assert/

#define STACKSIZE 5

class Stack {
	private:
		int  top; // Index welcher auf „top of the stack“ zeigt
		int* stack; // Speicherplatz fuer die Elemente von Stack
		int  stacksize;

	public:
		Stack(void);                    // default constructor
		Stack(unsigned int stacksize);
		~Stack(void);                   // destructor
		void Push(int value); // Methode um Integer-Zahl auf Stack ui pushen
		int Pop(void);
};



