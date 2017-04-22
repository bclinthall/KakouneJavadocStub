# auto generate javadoc stub
def javadocs %{
    # Save current selection to register c
    exec '"cZ'
    # Select the declaration, and save the selection to register a
    exec x
    # exec F<left-curly>
    exec '"aZ'
    # Select the indentation at the front of the line and
    # yank it.  Then write an indented "\**" above, followed
    # by "* Description goes here." on the next line.
    exec -draft 'gihGHy"azO/**<esc>gHPo * Description goes here.<esc>'

    # We might be dealing with a class or interface definition
    try %{
        # Select the parameters
        exec '"azs.*\)<ret>s[a-zA-Z][a-zA-Z0-9_]*\s*[,)]<ret>H'

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
            exec '"azs[a-zA-Z][a-zA-Z0-9_]*\s+[a-zA-Z][a-zA-Z0-9_]*\s*\(<ret>'
            # select the first of those words
            exec 's[a-zA-Z][a-zA-Z0-9_]*\s<ret>s\b.*\b<ret>'
            # discard the selection if it is not a non-void return type
            # Recall, we might be in a constructor
            exec '<a-K>(public|private|protected|void)<ret>' 
            # write a @return line
            exec 'y"azO* @return <esc>'
            
        }
    }

    # write the final */
    exec -draft '"azO*/'
    # restore original selection
    exec '"cz'
}
