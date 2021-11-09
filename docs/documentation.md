# Docs

> ## Object
> - ### a table that represents an on-screen object.
> - ### works just as a normal Drawing object would.
> - ### Object Types:
>     - Gui
>     - Frame
>     - TextButton
>     - TextLabel

<br>
</br>

> ## Class
> 
> - ### Class:CreateObject{type = <string> (ObjectType), ...}
>    - ### See [Object Types](#object-types) for a list of object types
>    - ### Returns a new Object
>    - ### ... represents normal Drawing object properties.
>    - ### example:
>    ```lua
>    Class:CreateObject{type = 'Frame', Transparency = .5}
>    ```
