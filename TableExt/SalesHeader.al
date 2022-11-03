tableextension 60010 SalesHeader extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(60001; "Return Doc No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}