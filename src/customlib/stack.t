/* Copyright (c) 2000 by Kevin Forchione.  All Rights Reserved. */
/*
 *  TADS LIBRARY EXTENSION
 *  STACK.T				
 *  version 1.0
 *
 *	stack.t implements a dynamically created FIFO or LIFO stack and a
 *  Vector class that can be used for list manipulation.
 *  
 *----------------------------------------------------------------------
 *  REQUIREMENTS
 *
 *      + HTML TADS 2.2.6 or later
 *
 *----------------------------------------------------------------------
 *  IMPORTANT LIBRARY INTERFACE AND MODIFICATION
 *
 *      None.
 *
 *----------------------------------------------------------------------
 *  COPYRIGHT NOTICE
 *
 *  	You may modify and use this file in any way you want, provided that
 *		if you redistribute modified copies of this file in source form, the
 *   	copies must include the original copyright notice (including this
 *   	paragraph), and must be clearly marked as modified from the original
 *   	version.
 *
 *------------------------------------------------------------------------------
 *  REVISION HISTORY
 *
 *		08-Mar-00:	Creation.
 */

#define __STACK_MODULE_

#pragma C+

/*
 *  Stack: object
 *
 *  This implements a FIFO (First-In-First-Out) or LIFO
 *  (Last-In-First-Out) stack that can be used for pushing and popping.
 *  The Stack will automatically create a Vector class object, which it
 *  uses for keeping track of pushed objects.
 *
 *  To use a stack simply create it dynamically. The Stack default is
 *  LIFO. If you wish it to behave as a FIFO stack simply set its isLIFO
 *  attribute to nil.
 *
 *      local stack = new Stack;
 *      stack.isLIFO = nil;
 *
 *  You can push items onto the stack with the stack's push method:
 *
 *      stack.push(item);
 *
 *  and pop items off the stack using its pop method:
 *
 *      item = stack.pop;
 *
 *  When the stack is no longer needed you can delete it with the delete
 *  statement. The stack will automatically clean-up the Vector class
 *  object that it dynamically created.
 */
class Stack: object
    isLIFO = true
    vector2 = nil    // pointer to dynamically-created Vector class obj
    /*
     *  Push an item onto the stack. All items are pushed to the top of
     *  the stack.
     */
    push(item) = {
        self.vector2.addElement(item);
    }
    /*
     *  Push an item to the bottom of the stack.
     */
    pushB(item) = {
        self.vector2.addElementToHead(item);
    }
    /*
     *  Pop an item off the stack. If stack.isLIFO then it pops the
     *  item from the top of the stack; otherwise it pops the item from
     *  the bottom of the stack.
     */
    pop = {
        local item;
        if (self.isLIFO)
        {
            item = self.vector2.elementAt(self.vector2.getSize);
            self.vector2.removeElementAt(self.vector2.getSize);
        }
        else
        {
            item = self.vector2.elementAt(1);
            self.vector2.removeElementAt(1);
        }
        return item;
    }
    /*
     *  Returns a boolean indicating whether the stack is empty or not.
     */
    isEmpty = {
        return self.vector2.isEmpty;
    }
    /*
     *  Returns the size of the stack.
     */
    getSize = {
        return self.vector2.getSize;
    }
    construct = {self.vector2 = new Vector;}
    destruct = {delete self.vector2;}
;

/*
 *  Vector: object
 *
 *  The Vector class can be used to manipulate lists.
 */
class Vector: object
    list = []
    /*
     *  Add an element to the tail of the list.
     */
    addElement(item) = {
        self.list += item;
    }
    /*
     *  Add an element to the head of the list.
     */
    addElementToHead(item) = {
        local newlist = [];
        
        newlist += item;
        newlist += self.list;
        self.list = newlist;
    }
    /*
     *  Add item to the list at pos n. If n > list.getSize the list
     *  is padded with nil values to a length of n-1 before adding item.
     */
    addElementAt(item, n) = {
        local newlist = [], l1 = [], l2 = [];
        
        if (n > self.getSize) self.padVector(n-1);
        
        newlist += self.sublist(1, n-1);
        newlist += item;
        newlist += self.sublist(n, self.getSize);
        self.list = newlist;
    }
    /*
     *  Pad the list with nil elements to the length of n.
     */
    padVector(n) = {
        local i, len;
        
        len = self.getSize + 1;
        for (i = len; i <= n; ++i)
            self.list += nil;
    }
    /*
     *  Left pad the list with nil elements to the length of n.
     */
    lpadVector(n) = {
        local i, len, newlist = [];
       
        len = n - self.getSize;
        for (i = 1; i <= len; ++i)
            newlist += nil;
            
        newlist += self.list;
        self.list = newlist;
    }
    /*
     *  Remove the element at pos n in the list.
     */
    removeElementAt(n) = {
        local i, len, newlist = [];
        
        len = self.getSize;
        for (i = 1; i <= len; ++i)
        {
            if (i != n)
                newlist += self.list[i];
        }
        self.list = newlist;
    }
    /*
     *  Remove the first occurrence (from left to right) of item from
     *  the list.
     */
    removeFirstOccurrence(item) = {
        local n = self.posFirstOccurrence(item);
        
        if (0 < n && n <= self.getSize)
            self.removeElementAt(n);
    }
    /*
     *  Remove the last occurrence (from left to right) of item from
     *  the list.
     */
    removeLastOccurrence(item) = {
        local n = self.posLastOccurrence(item);
        
        if (0 < n && n <= self.getSize)
            self.removeElementAt(n);
    }
    /*
     *  Remove all occurrences of item from the list.
     */
    removeAllOccurrence(item) = {
        self.list -= [item];
    }
    elementAt(n) = {
        if (0 < n && n <= self.getSize)
            return self.list[n];
        else return nil;
    }
    /*
     *  Return the pos n for the first occurrence (from left to right) of 
     *  item in the list.
     */
    posFirstOccurrence(item) = {
        local f = find(self.list, item);
        if (f) return f;
        return 0;
    }
    /*
     *  Return the pos n for the last occurrence (from left to right) of
     *  item in the list.
     */
    posLastOccurrence(item) = {
        local i, len;
        
        for (i = length(self.list); i > 0; --i)
        {
            if (self.list[i] == item)
                return i;
        }
        return 0;
    }
    /*
     *  Return a list of elements that are positions in the list for
     *  all occurrences of item.
     */
    posAllOccurrence(item) = {
        local i, len, newlist = [];
        
        len = length(self.list);
        for (i = 1; i <= len; ++i)
        {
            if (self.list[i] == item)
                newlist += [i];
        }
        return newlist;
    }
    /*
     *  Return a count of all occurrences of item in the list.
     */
    countOccurrence(item) = {
        local n = self.posAllOccurrence(item);
        
        return length(n);
    }
    /*
     *  Return a sublist of list, starting from pos for a length len
     *  (if provided). if len is not provided then it is the length of 
     *  the remainder of the list. If len is greater than the length 
     *  of the list then the sublist contains the remainder of the list.
     *  If pos is greater than the length of the list then an empty list
     *  is returned.
     */
    sublist(pos, ...) = {
        local i, len, newlist = [];
        
        if (argcount > 1) len = getarg(2);
        if (len == nil) len = self.getSize - pos + 1;
        
        for (i = pos; i <= pos + len - 1; ++i)
        {
            if (self.getSize >= i)
                newlist += self.list[i];
            else break;
        }
        return newlist;
    }
    /*
     *  Returns the length of the list.
     */
    getSize = {return length(self.list);}
    /*
     *  Returns a boolean indicating whether the list is empty or not.
     */
    isEmpty = {
        if (self.getSize)
            return nil;
        else return true;
    }
    construct = {}
    destruct = {}
;  

#pragma C-
