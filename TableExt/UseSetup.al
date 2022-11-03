tableextension 60009 USerSetupExt extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(60001; "Allow Bill Post"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}