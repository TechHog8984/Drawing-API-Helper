# Docs


> ## Helper
> ### This is returned by [the main script](/script/latest)
> - ### Functions:
>     - ### Helper:Create\[OBJECTNAME](Properties)
>         - ### Replace OBJECTNAME with an object types from the [Object Types](Object%20Types.md) list.
>         - ### Example:
>             ```lua
>             local Rectangle = Helper:CreateRectangle{Name = 'Rectangle', Position = Vector2.new(960, 540)};
>             ```

> ## Object
> ### This is returned by any of the Helper:Create functions, as described above [here](#helpercreateobjectnameproperties).
> - ### Properties:
>   - ### This is a list of all default Object Properties:
>     - #### \_\_exists \<bool>:
>         - #### Must be accessed throught rawget.
>         - #### Becomes false whenever you destroy the Object.
>     - #### Name \<string>:
>         - #### Determines what should be returned when you tostring the Object.
>     - #### ClassName \<string>:
>         - #### Determines the default Name of an object, if nothing is provided.
>         - #### Is READONLY, meaning that you cannot change this (although for advanced users wanting to make use this to make custom objects, you can view the source code and use rawget and rawset.)
>     - #### Visible \<boolean>:
>         - #### Determines whether the object is visible or not (whether you can see it or not, true being you can see the object and false being you cannot.)
>     - #### ZIndex \<number>:
>         - #### Determines the order the Object being rendered (a higher ZIndex means an Object will render ABOVE / OVER one with a lower ZIndex and vice versa.)
>     - #### Transparency \<number>:
>         - #### Determines the transparency of the Object ( a transparency of 1 means fully visible, .5 half visible, and 0 invisible)
>     - #### Color \<Color3>:
>         - #### Is a property for all Objects EXCEPT FOR IMAGE.
>
> - ### Events:
>   - ### This is a list of all default Object Events:
>   - ### All Events are created from [this](https://github.com/TechHog8984/Event-Manager) script.
>     - #### Changed:
>       - #### Fired whenever a property of the Object is changed.
>       - #### Returns the property name and the new value of the property.
>     - #### Note that the below mouse events only work for Rectangles and Quad and that the Quad detection is very bad.
>     - #### MouseEnter:
>       - #### Fired whenever the mouse hovers over the Object.
>     - #### MouseLeave:
>       - #### Fired whenever the mouse stops hovering over the Object.
>     - #### MouseButton1Down:
>       - #### Fired whenever the MouseButton1 (left click) is pressed down on the Object.
>     - #### MouseButton1Up:
>       - #### Fired whenever a MouseButton1 (left click) click is released on the Object.
>     - #### MouseButton1Click:
>       - #### Fired whenever the MouseButton1 (left click) clicks on the Object.
>       
>     - #### MouseButton2Down:
>       - #### Fired whenever the MouseButton2 (right click) is pressed down on the Object.
>     - #### MouseButton2Up:
>       - #### Fired whenever a MouseButton2 (right click) click is released on the Object.
>     - #### MouseButton2Click:
>       - #### Fired whenever the MouseButton2 (right click) clicks on the Object.
