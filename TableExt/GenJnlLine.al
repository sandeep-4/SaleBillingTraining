tableextension 60003 GenJnlExt extends "Gen. Journal Line"
{
    fields
    {
        // Add changes to table fields here
        field(60001; "Training"; Text[20])
        {
            DataClassification = ToBeClassified;
        }

        field(60002; "Sum of Tax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}