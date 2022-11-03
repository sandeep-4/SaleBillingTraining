tableextension 60004 GLEntryExt extends "G/L Entry"
{
    fields
    {
        // Add changes to table fields here
        field(60001; "Training"; Text[20])
        {
            DataClassification = ToBeClassified;
        }

        field(60077; "Tax Sum"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}