pageextension 60004 SalesLine extends "Sales Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter(Quantity)
        {
            field("Tax Amount"; Rec."Tax Amount")
            {
                ApplicationArea = All;
                Editable = false;
                //FieldPropertyName = FieldPropertyValue;
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