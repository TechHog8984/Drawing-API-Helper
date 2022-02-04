# Docs


> ## Helper
> ### This is returned when you loadstring [the main script](/script/latest)
> - ### Functions:
>     - ### Helper:Create\[OBJECTNAME](Properties)
>     - ### Replace OBJECTNAME with an object types from the [Object Types](Object%20Types.md) list.
>     - ### Example:
>         ```lua
>         local Rectangle = Helper:CreateRectangle{Name = 'Rectangle', Position = Vector2.new(960, 540)};
>         ```

> ## Object
> ### This is returned when you run Helper:Create\[OBJECTNAME], as described above [here](#helpercreateobjectnameproperties)
> - ### Properties:
>   - ### This is a list of all default Object properties:
>     - #### Name \<string>:
>         - #### Determines what should be returned when you tostring the Object.
>     - #### ClassName \<string>:
>         - #### Determines the default Name of an object, if nothing is provided.
>         - #### Is READONLY, meaning that you cannot change this (although if you really want to, you can just view the source and use rawget & rawset.)
>     - #### Visible \<boolean>:
>         - #### Determines whether the object is visible or not (whether you can see it or not, true being you can see the object and false being you cannot.)
>     - #### ZIndex \<number>:
>         - #### Determines the order of Objects being rendered (a higher ZIndex means an Object will render ABOVE / OVER one with a lower ZIndex and vice versa.)
>     - #### Transparency \<number>:
>         - #### Determines the transparency of the Object ( a transparency of 1 means fully visible, .5 half visible, and 0 invisible)
>     - #### Color \<Color3>:
>         - #### Is a property for all Objects EXCEPT THE IMAGE.
>
