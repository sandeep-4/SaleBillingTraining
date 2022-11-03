tableextension 60002 ItemExt extends Item
{
    fields
    {
        // Add changes to table fields here
        field(60000; "Bill Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}