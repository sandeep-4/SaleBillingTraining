tableextension 60011 ItemJnlLineExt extends "Item Journal Line"
{
    fields
    {
        // Add changes to table fields here

        field(60001; "Tax Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}