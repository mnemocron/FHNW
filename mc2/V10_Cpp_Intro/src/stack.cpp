/*******************************************************************************
 * @file        stack.cpp
 * @brief
 * @details
 * @version     1.0
 * @author      Simon Burkhardt
 * @date        2020.01.05
*******************************************************************************/

#include <stack.hpp>
#include <cassert>    // see: http://www.cplusplus.com/reference/clibrary/cassert/assert/
#include <stdexcept>

Stack::Stack(void){
	// irgendwas initialisieren...
	this->stacksize = STACKSIZE;
	this->top=0;
	this->stack = new int [this->stacksize];
	for(int i=0; i<STACKSIZE; i++){
		this->stack[i] = 0;
	}
	// irgendwas debug-melden ?
}

Stack::Stack(unsigned int stacksize){
	this->stacksize = stacksize;
	this->top=0;
	this->stack = new int [this->stacksize];  // dynamisch erstellen
}

Stack::~Stack(void){
	delete []stack;
}

void Stack::Push(int value) {
	// assert((top >= 0) && (top < this->stacksize));    // beendet Programm bei Stack Over- oder Underflow
	if(! ((top >= 0) && (top < this->stacksize)) )
		std:: out_of_range("stack overflow");
	this->stack [top++] = value;

}

int Stack::Pop(void){
	// assert((top >= 0) && (top < this->stacksize));
	if(! ((top >= 0) && (top < this->stacksize)) )
		std:: out_of_range("stack underflow");
	return this->stack [--top];    // pre-decrement, nicht post-decrement
}




