This is a command for the [Kakoune text editor](https://github.com/mawww/kakoune). 

It assumes that you have a single selection in the first line of a method or constructor when the command it called. 

It will generate a javadoc comment stub including `@param`, `@throws` and `@return` tags is necessary.

---

Currently, it only works with one line declarations.  When I try to put `F{` in line 7, I get an error `unterminated string '%{...}'`.  If `F{` would just do what it was supposed to do, then this would work for multiline declarations.  Any help would be appreciated.
