from __future__ import annotations

from pikepdf import Pdf

OLD_PREFIXES = (
    "https://josephwardle.com",
    "http://josephwardle.com",
    "josephwardle.com",
)
NEW_URL = "https://josephwardle.com/?src=disney-2025"

input_pdf = "2025_disney_resume.pdf"   # original
output_pdf = "output.pdf" # patched


def main() -> None:
    with Pdf.open(input_pdf) as pdf:
        changed = 0

        for page in pdf.pages:
            annots = page.get("/Annots", [])
            for annot in annots:
                action = annot.get("/A")
                if not action:
                    continue

                uri = action.get("/URI")
                if not uri:
                    continue

                uri_str = str(uri)
                if uri_str.startswith(OLD_PREFIXES):
                    action["/URI"] = NEW_URL
                    changed += 1

        pdf.save(output_pdf)
        print(f"Updated {changed} link(s). Saved as {output_pdf!r}.")


if __name__ == "__main__":
    main()

