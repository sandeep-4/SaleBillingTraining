pageextension 60009 UserSetupExt extends "User Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Allow Posting From")
        {
            field("Allow Bill Post"; Rec."Allow Bill Post")
            {
                ApplicationArea = All;
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