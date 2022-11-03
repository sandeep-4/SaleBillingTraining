pageextension 60002 ItemCardExt extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Bill Amount"; "Bill Amount")
            {
                ApplicationArea = All;
                //  FieldPropertyName = FieldPropertyValue;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}