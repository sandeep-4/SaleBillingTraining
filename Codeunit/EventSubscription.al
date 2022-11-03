codeunit 60002 EventSubs
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostGLAccOnBeforeInsertGLEntry', '', false, false)]
    local procedure OnPostGLAccOnBeforeInsertGLEntry(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
        GenJournalLine.TestField(Training);
        GLEntry.Training := GenJournalLine.Training;
        GLEntry."Tax Sum" := GenJournalLine."Sum of Tax";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeader', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    var
        SalesLine: Record "Sales Line";
        SumAmt: Decimal;
    begin
        Clear(SumAmt);
        SalesLine.Reset();
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        If SalesLine.FindSet() then
            repeat
                SumAmt += SalesLine."Tax Amount";
            until SalesLine.Next() = 0;

        GenJournalLine."Sum of Tax" := SumAmt;
        GenJournalLine.Training := 'test';

    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesLine', '', false, false)]
    local procedure OnAfterCopyItemJnlLineFromSalesLine(SalesLine: Record "Sales Line"; var ItemJnlLine: Record "Item Journal Line")
    begin

        ItemJnlLine."Tax Amt" := SalesLine."Tax Amount";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertItemLedgEntry', '', false, false)]
    local procedure OnBeforeInsertItemLedgEntry(ItemJournalLine: Record "Item Journal Line"; var ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        ItemLedgerEntry."Line Tax Amt" := ItemJournalLine."Tax Amt";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertValueEntry', '', false, false)]
    local procedure OnBeforeInsertValueEntrytest(ItemJournalLine: Record "Item Journal Line"; var ValueEntry: Record "Value Entry")
    begin
        ValueEntry."Line Tax Amt" := ItemJournalLine."Tax Amt";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnAfterCopySalesHeaderDone', '', false, false)]
    local procedure OnAfterCopySalesHeaderDone(FromSalesInvoiceHeader: Record "Sales Invoice Header"; var ToSalesHeader: Record "Sales Header")
    begin
        //  ToSalesHeader."Return Doc No." := FromSalesInvoiceHeader."No.";
        //ToSalesHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeCopySalesDocument', '', false, false)]
    local procedure onBeforeCopy(FromDocumentNo: Code[20]; var ToSalesHeader: Record "Sales Header")
    begin
        ToSalesHeader."Return Doc No." := FromDocumentNo;
        ToSalesHeader.Modify();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header")
    var
        PostedCreditMemo: Record "Sales Cr.Memo Header";
    begin

        if SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo" then begin
            PostedCreditMemo.Reset();
            PostedCreditMemo.SetRange("Return Doc No.", SalesHeader."Return Doc No.");
            if PostedCreditMemo.FindFirst() then
                Error('You vant post against same invoice twice.');

        end;

    end;

    //OnBeforeCopySalesDocument





}