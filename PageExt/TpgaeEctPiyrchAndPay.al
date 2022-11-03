pageextension 60000 PurchasePayExt extends "Purchases & Payables Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Vendor Nos.")
        {
            field("Header No."; "Header No.")
            {
                ApplicationArea = All;
                // FieldPropertyName = FieldPropertyValue;
            }
            field("Bill Tax %"; "Bill Tax %")
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