import importlib.util
import struct
import tempfile
import unittest
from pathlib import Path


SCRIPT = Path(__file__).parents[1] / "scripts" / "scale_xcursor.py"


def load_module():
    spec = importlib.util.spec_from_file_location("scale_xcursor", SCRIPT)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def write_single_image_cursor(path: Path) -> None:
    pixels = [0xFF112233, 0xFF445566]
    image = struct.pack(
        "<9I", 36, 0xFFFD0002, 32, 1, 2, 1, 1, 0, 0
    ) + struct.pack("<2I", *pixels)
    path.write_bytes(
        b"Xcur"
        + struct.pack("<3I", 16, 1, 1)
        + struct.pack("<3I", 0xFFFD0002, 32, 28)
        + image
    )


class ScaleXcursorTest(unittest.TestCase):
    def test_scale_cursor_file_rewrites_nominal_size_dimensions_hotspot_and_pixels(self):
        with tempfile.TemporaryDirectory() as temporary_directory:
            temporary_path = Path(temporary_directory)
            module = load_module()
            source = temporary_path / "source.cursor"
            target = temporary_path / "target.cursor"
            write_single_image_cursor(source)

            module.scale_cursor_file(source, target, 96)

            data = target.read_bytes()
            self.assertEqual(data[:4], b"Xcur")
            _, _, toc_count = struct.unpack_from("<3I", data, 4)
            self.assertEqual(toc_count, 1)
            _, subtype, offset = struct.unpack_from("<3I", data, 16)
            self.assertEqual(subtype, 96)
            _, image_type, image_subtype, _, width, height, xhot, yhot, delay = struct.unpack_from("<9I", data, offset)
            self.assertEqual(image_type, 0xFFFD0002)
            self.assertEqual(image_subtype, 96)
            self.assertEqual((width, height, xhot, yhot, delay), (6, 3, 3, 0, 0))
            pixels = struct.unpack_from("<18I", data, offset + 36)
            self.assertEqual(pixels[:6], (0xFF112233,) * 3 + (0xFF445566,) * 3)
            self.assertEqual(pixels[6:12], pixels[:6])


if __name__ == "__main__":
    unittest.main()
