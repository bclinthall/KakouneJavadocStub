# auto generate javadoc stub
def javadocs %{
    # Save current selection to register c
    exec '"cZ'
    # Select the declaration, and save the selection to register a
    exec gh
    exec F{
    #}  The parser can't handle an unmatched left curly bracket, but
    # the commented right curly will trick it into thinking everything is alright.

    # We've worked hard to select the whole declaration.
    # Let's save that selection to register a.
    exec '"aZ'

    # Open the javadoc comment
    exec 'O/**<esc>'

    # Copy the indentation level of declaration to the /**
    exec 'jx<a-;>K<a-s><a-&>'

    # write the next comment line
    exec '"azO * Description goes here.<esc>'

    # We might be dealing with a class or interface definition
    try %{
        # select the part of the declaration before )
        exec '"azs.*\)<ret>'
        # select the parameter declarations
        exec 's[a-zA-Z][a-zA-Z0-9_\<\>]*\s+[a-zA-Z][a-zA-Z0-9_]*\s*[,)]<ret>'
        # narrow selection to just parameter names
        exec 's[a-zA-Z][a-zA-Z0-9_]*\s*[,)]<ret>H'

        # write a line of javadoc for each parameter
        exec -draft -itersel 'y"azO* @param <esc>p'

        try %{
            # search for throws
            exec '"azs\bthrows\b<ret>'
            # we get an error if none is found.
            # Now we select to end of line
            exec 'lGl'
            #capture the error names
            exec s\b[a-zA-Z][a-zA-Z0-9_]*\b<ret>

            # write a line of javadoc for each exception thrown
            exec -draft -itersel 'y"azO* @throws <esc>p'
        }
        # select the return type, if there is one.
        try %{
            # select the two words before the open parenths
            exec '"azs[a-zA-Z][a-zA-Z0-9_\<\>]*\s+[a-zA-Z][a-zA-Z0-9_]*\s*\(<ret>'
            # select the first of those words
            exec 's[a-zA-Z][a-zA-Z0-9_\<\>]*\s<ret>s\b.*\b<ret>'
            # discard the selection if it is not a non-void return type
            # Recall, we might be in a constructor
            exec '<a-K>(public|private|protected|void)<ret>' 
            # write a @return line
            exec 'y"azO* @return <esc>'
            
        }
    } catch %{
        # we are probably in a class or interface definition
        exec '"azO* @version 1<ret>*@author <esc>'
    }

    # write the final */
    exec -draft '"azO*/'
    # restore original selection
    exec '"cz'
}
