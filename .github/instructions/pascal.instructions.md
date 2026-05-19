---
applyTo: "**/*.pas,**/*.pp,**/*.dpr,**/*.dpk,**/*.lpr,**/*.inc"
---

# Pascal Development — Copilot Instructions

## Language & Dialect
- Target **Free Pascal (FPC) 3.2+** by default; note Delphi compatibility where it diverges
- Use `{$mode objfpc}{$H+}` at the top of every unit unless the project sets a global mode
- `{$H+}` enables long (AnsiString) strings — always on; never use ShortString for general text
- Enable hints and warnings: `{$HINTS ON}{$WARNINGS ON}`

## Naming Conventions

| Construct | Convention | Example |
|---|---|---|
| Units | PascalCase, noun | `ShipmentTracker` |
| Classes / Records | `T` prefix + PascalCase | `TShipmentRecord` |
| Interfaces | `I` prefix + PascalCase | `ICarrierService` |
| Exceptions | `E` prefix + PascalCase | `EConnectionFailed` |
| Pointers | `P` prefix + PascalCase | `PShipmentRecord` |
| Constants | `ALL_CAPS_SNAKE` or `c` prefix | `MAX_RETRIES = 3` |
| Global vars | `g` prefix | `gAppConfig` |
| Private fields | `F` prefix | `FItemCount` |
| Parameters | camelCase | `shipmentId` |
| Local vars | camelCase | `retryCount` |
| Boolean vars/props | `Is`, `Has`, `Can` prefix | `IsConnected`, `HasItems` |

## File & Unit Structure

Every unit follows this order:
```pascal
unit UnitName;

{$mode objfpc}{$H+}
{$HINTS ON}{$WARNINGS ON}

interface

uses
  { standard library units first, then third-party, then project units }
  SysUtils, Classes,
  { blank line }
  ProjectBase;

const
  ...

type
  ...

var
  ...

implementation

uses
  { implementation-only units here }

{ class / procedure implementations }

initialization
  { optional: module setup }

finalization
  { optional: cleanup }

end.
```

## Classes & OOP

- Always use `TObject` (or a more specific base) as the ancestor — never define a class with no ancestor
- Declare destructors as `destructor Destroy; override;` — always call `inherited Destroy` as the **last** statement
- Free owned objects in `Destroy`, not `Finalize`; always nil after free: `FreeAndNil(FChild)`
- Use `property` with explicit `read`/`write` accessors; avoid direct public field access
- Mark virtual methods that must be overridden with `abstract`
- Use `sealed` (Delphi) or document intent when a class is not designed for subclassing

```pascal
type
  TShipment = class(TObject)
  private
    FId:     string;
    FWeight: Double;
    function  GetId: string;
    procedure SetWeight(AValue: Double);
  public
    constructor Create(const AId: string; AWeight: Double);
    destructor  Destroy; override;
    property Id:     string read GetId;
    property Weight: Double read FWeight write SetWeight;
  end;
```

## Memory Management

- **Always** pair every `Create` with a `Free` (or `FreeAndNil`) in a `try..finally` block
- Use `FreeAndNil` instead of `Free` when the variable may be tested for `nil` later
- Prefer stack-allocated records over heap objects for small, short-lived data
- Use `TObjectList<T>` (or `specialize TFPGObjectList<T>`) with `OwnsObjects := True` for owned collections

```pascal
var
  LShipment: TShipment;
begin
  LShipment := TShipment.Create('LT-10042', 12.5);
  try
    ProcessShipment(LShipment);
  finally
    FreeAndNil(LShipment);
  end;
end;
```

## Error Handling

- Raise typed exceptions derived from `Exception` (or a project base exception)
- Never use `{$IFDEF DEBUG} Writeln(...)` as a substitute for structured exception handling
- Always specify the exception class in `except` clauses — avoid bare `except`
- Re-raise with `raise` (no argument) to preserve the original stack; never `raise E` in a catch block
- Use `EArgumentException`, `EInvalidOperation`, `ERangeError` from `SysUtils` where appropriate

```pascal
{ ✅ correct }
try
  Result := ParseShipmentId(RawInput);
except
  on E: EConvertError do
    raise EInvalidShipmentId.CreateFmt('Bad id: %s — %s', [RawInput, E.Message]);
end;

{ ❌ avoid }
except
  Writeln('Error: ', E.Message);  // swallowed, silent
end;
```

## Strings & Text

- Use `string` (AnsiString with `{$H+}`) for general text
- Use `UnicodeString` / `WideString` explicitly when Unicode handling is required
- Format with `SysUtils.Format` — never concatenate inside loops
- Trim user input with `Trim()` before validation
- Use `SameText` for case-insensitive comparison (avoids locale issues vs `LowerCase`)
- Sanitize any string going into SQL with parameterized queries — never concatenate SQL

## Generics (FPC 3.2+)

- Prefix generic type parameters with `T`: `specialize TStack<TShipment>`
- Use `{$modeswitch advancedrecords}` for records with methods when targeting FPC
- Prefer generic collections (`TFPGList`, `TFPGObjectList`, `TFPGMap`) over untyped `TList`

## Interfaces & Dependency Injection

- Use interfaces for service boundaries and testability
- Reference-count via `IInterface` (`_AddRef`/`_Release`) is automatic — do not mix interface and object references to the same instance
- Prefer constructor injection over property injection; document required dependencies

## Constants & Magic Numbers

- No magic numbers in logic — declare all domain constants in a `const` section or a dedicated `Constants` unit
- Use typed constants (`const MAX_WEIGHT: Double = 1000.0;`) over untyped when the type matters

## Code Style

- Indent with **2 spaces** — no tabs
- `begin`/`end` on their own lines for procedure/function bodies; single-line `if` allowed only for trivial guards
- One statement per line
- Limit line length to **120 characters**
- Comment with `//` for single-line; `{ }` for block comments and compiler directives only
- Use `{ TODO: }` and `{ FIXME: }` markers — never leave silent dead code

## Compiler Directives

- Keep directives at the **top of the unit** or in a shared `{$INCLUDE config.inc}`
- Acceptable inline directives: `{$RANGECHECKS ON/OFF}` around hot loops, `{$OVERFLOWCHECKS OFF}` with a comment
- Never use `{$GOTO}` — use structured control flow
- Avoid `{$DEFINE}` feature flags scattered across files; centralise in `config.inc`

## Testing

- Structure tests as FPCUnit or DUnit2 `TTestCase` subclasses
- Name test methods `Test_<MethodName>_<Scenario>_<ExpectedOutcome>`
- One logical assertion per test method; use `AssertEquals`, `AssertTrue`, `AssertRaisesException`
- Test files live in a `tests/` subdirectory mirroring the `src/` structure
- Never `Writeln` from production code for debugging — use a proper logging unit

## What NOT to Do

- ❌ Do not use `goto` or `label`
- ❌ Do not use untyped `var` / `const` parameters without a comment explaining why
- ❌ Do not use `Result` as an intermediate accumulator in complex functions — assign once at the end or use a local variable
- ❌ Do not catch `Exception` bare and swallow it silently
- ❌ Do not use global mutable state; isolate in a singleton with thread-safe access if unavoidable
- ❌ Do not mix `AnsiString` and `WideString` without explicit conversion
