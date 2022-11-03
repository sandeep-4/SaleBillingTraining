tableextension 60015 SalesCrediMemoExt extends "Sales Cr.Memo Header"
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