tableextension 60013 ValueEntryExt extends "Value Entry"
{
    fields
    {
        // Add changes to table fields here

        field(60001; "Line Tax Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}